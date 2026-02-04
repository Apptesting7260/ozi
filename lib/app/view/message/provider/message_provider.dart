import 'package:flutter/cupertino.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import '../../../core/constants/app_urls.dart';
import '../../../core/utils/get_utils.dart';
import '../../../data/models/chat_models/check_conversion_model.dart';
import '../../../data/models/chat_models/conversion_list_model.dart';
import '../../../data/network/web_socket_connection_service.dart';
import '../../../data/response/api_response.dart';
import '../../../data/storage/user_preference.dart';
import '../../../routes/app_routes.dart';
import '../message_isolates/message_isolates.dart';

class MessageProvider extends ChangeNotifier {
  String? userId;
  final ScrollController scrollController = ScrollController();

  bool isLoading = false;
  int page = 1;
  bool isPagination = true;

  ApiResponse<ConversionListModel> _allConversionData = ApiResponse.loading();
  ApiResponse<ConversionListModel> get allConversionData => _allConversionData;

  SocketController? _socket;

  MessageProvider() {
    initProvider();
  }

  Future<void> initProvider() async {
    await initUser();
    _socket = navigatorKey.currentContext?.read<SocketController>();
    startScrollListener();
    // listenToConversationUpdates();
  }

  Future<void> initUser() async {
    userId = await UserPreference.returnUserId() ?? '';
  }

  void updateAllConversionData(ApiResponse<ConversionListModel> value) {
    _allConversionData = value;
    notifyListeners();
  }

  void readAllCounts(String id) {
    final conversations = _allConversionData.data?.data;
    if (conversations == null) return;

    for (final convo in conversations) {
      if (convo.sId == id) {
        convo.unreadMsgCount = '0';
        break;
      }
    }
    notifyListeners();
  }

  void startScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading && isPagination) {
          getAllConversions(false);
        }
      }
    });
  }

  Future<void> getAllConversions(bool resetPage) async {
    if(isLoading) return;
    try {
      if (userId == null || userId == '') {
        await initUser();
      }
      if (resetPage) {
        updateAllConversionData(ApiResponse.loading());
        page = 1;
      }

      isLoading = true;
      await initUser();

      // Cancel previous listeners
      _socket?.off(AppUrls.conversationListEvent);

      // Create a completer to wait for the socket response
      final completer = Completer<void>();

      // Start 7 second timeout
      final timeoutTimer = Timer(const Duration(seconds: 7), () {
        if (!completer.isCompleted) {
           completer.completeError("Request timed out");
          _socket?.off(AppUrls.conversationListEvent);
        }
      });

      // Send socket request
      _socket?.sendMessage(AppUrls.conversationListEvent, {
        "userId": userId ?? '',
        "page": page,
        "limit": 10,
      });

      // Listen for response
      _socket?.listenToEvent(AppUrls.conversationListEvent, (p0) async {
        // if (completer.isCompleted) return; // ignore if timeout already happened
      if(listen==false){
        listenToConversationUpdates();
      }
        _socket?.off(AppUrls.conversationListEvent);
        timeoutTimer.cancel(); // stop timeout timer

        if (p0 is Map<String, dynamic>) {
          final data = p0;
          final alldata = await parseConversationModelInBackground(data);

          if (page == 1) {
            updateAllConversionData(ApiResponse.completed(alldata));
          } else {
            final existing = allConversionData.data?.data ?? [];
            existing.addAll(alldata.data ?? []);
            if (alldata.data?.isEmpty ?? true) isPagination = false;
            notifyListeners();
          }

          isLoading = false;
          page++;
          completer.complete(); // mark response completed
        }
      });

      // Wait for either response OR timeout
      await completer.future;

    } catch (e) {
      debugPrint("Error while processing conversation list: $e");
      updateAllConversionData(ApiResponse.error("Communication Error"));
      isLoading = false;
    }
  }




  bool listen = false;

  void listenToConversationUpdates() {
    listen = true;
    _socket?.listenToEvent(AppUrls.updateConverstationEvent, (p0) async {
      if (p0 is Map<String, dynamic> && p0['status'] == true) {
        final updatedData =
        await parseConversationListInBackground(p0['data']);
        final list = allConversionData.data?.data ?? [];
        final index = list.indexWhere((e) => e.sId == updatedData.sId);
        if (index != -1) {
          list.removeAt(index);
        }
        list.insert(0, updatedData);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _socket?.off(AppUrls.conversationListEvent);
    _socket?.off(AppUrls.updateConverstationEvent);
    super.dispose();
  }

  //this function for send message to vendor for first time
  bool _sendLoading = false;
  bool get sendLoading => _sendLoading;
  updateSendLoading(bool value) {
    _sendLoading = value;
    notifyListeners();
  }

  Future<String?> getUserId() async {
    String myUserId = await UserPreference.returnUserId() ?? '';
    return myUserId;
  }

  Future<void> sendMessage(String receiverId) async {
    if (sendLoading) return;
    updateSendLoading(true);
    SocketController socket = navigatorKey.currentContext!.read();
    String? userId = await getUserId();
    socket.sendMessage(AppUrls.checkConversationEvent, {
      "senderId": userId ?? '',
      "receiverId": receiverId,
    });

    socket.listenToEvent(AppUrls.checkConversationEvent, (p0) {
      socket.off(AppUrls.checkConversationEvent);
      if (p0 is String) {
        final data = jsonDecode(p0);
        // use data['key']
        if (kDebugMode) {
          print("data string is $data");
        }
      } else if (p0 is Map) {
        final data = p0 as Map<String, dynamic>;
        CheckConverstionModel conversion = CheckConverstionModel.fromJson(data);
        if (conversion.status == true && conversion.data?.sId != null) {
          Navigator.pushNamed(
            navigatorKey.currentContext!,
            AppRoutes.messageDetailsScreen,
            arguments: {"conversion_id": conversion.data?.sId},
          );
        }

        if (kDebugMode) {
          print("data Map is $data");
        }
      }
      updateSendLoading(false);
    });
  }
}


