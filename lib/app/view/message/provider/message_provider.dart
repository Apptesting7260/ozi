import 'package:ozi/app/core/appExports/app_export.dart';
import '../../../core/constants/app_urls.dart';
import '../../../data/models/chat_models/conversion_list_model.dart';
import '../../../data/network/web_socket_connection_service.dart';
import '../../../data/response/api_response.dart';
import '../../../data/storage/user_preference.dart';
import '../message_isolates/message_isolates.dart';
import '../../../core/utils/toast.dart';

class MessageProvider extends ChangeNotifier {
  String? userId;
  final ScrollController scrollController = ScrollController();

  bool isLoading = false;
  int page = 1;
  bool isPagination = true;

  ApiResponse<ConversionListModel> _allConversionData = ApiResponse.loading();
  ApiResponse<ConversionListModel> get allConversionData => _allConversionData;

  SocketController? _socket;
  SocketController? get socket =>
      _socket ??= navigatorKey.currentContext?.read<SocketController>();

  MessageProvider() {
    initProvider();
  }

  int get unreadChatCount {
    final list = allConversionData.data?.data ?? [];

    return list.where((chat) {
      final count = int.tryParse(chat.unreadMsgCount ?? '0') ?? 0;
      return count > 0;
    }).length;
  }

  Future<void> initProvider() async {
    await initUser();
    _socket = socket;
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
    if (isLoading) return;
    try {
      if (userId == null || userId == '') {
        await initUser();
      }
      if (resetPage) {
        updateAllConversionData(ApiResponse.loading());
        page = 1;
        isPagination = true;
      }

      isLoading = true;
      await initUser();

      // Cancel previous listeners
      socket?.off(AppUrls.conversationListEvent);

      final completer = Completer<void>();
      final timeoutTimer = Timer(const Duration(seconds: 15), () {
        if (!completer.isCompleted) {
          completer.completeError("Request timed out");
          socket?.off(AppUrls.conversationListEvent);
        }
      });

      // 1. LISTEN FIRST - Listen for response BEFORE sending message
      socket?.listenToEvent(AppUrls.conversationListEvent, (p0) async {
        if (completer.isCompleted) return;

        if (listen == false) {
          listenToConversationUpdates();
        }

        socket?.off(AppUrls.conversationListEvent);
        timeoutTimer.cancel();

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
          completer.complete();
        } else {
          completer.completeError("Invalid response format");
        }
      });

      // 2. SEND MESSAGE - Pass resetPage as forceReconnect to fix the reported issue
      await socket?.sendMessage(
        AppUrls.conversationListEvent,
        {"userId": userId ?? '', "page": page, "limit": 10},
        forceReconnect:
            resetPage, // This ensures socket is re-established on pull-to-refresh
      );

      // Wait for either response OR timeout
      await completer.future;
    } catch (e) {
      debugPrint("Error while processing conversation list: $e");
      String errorMsg = "Connection Error, Please try again later.";
      if (e.toString().contains("timeout")) {
        errorMsg = "Request timed out";
      } else if (e.toString().contains("Connection error") ||
          e.toString().contains("WebSocketException")) {
        errorMsg = "Connection Error, Please try again later.";
      }

      updateAllConversionData(ApiResponse.error(errorMsg));
      isLoading = false;

      if (navigatorKey.currentContext != null) {
        errorToast(navigatorKey.currentContext!, errorMsg);
      }
    }
  }

  bool listen = false;

  void listenToConversationUpdates() {
    listen = true;
    socket?.listenToEvent(AppUrls.updateConverstationEvent, (p0) async {
      if (p0 is Map<String, dynamic> && p0['status'] == true) {
        final updatedData = await parseConversationListInBackground(p0['data']);
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
    socket?.off(AppUrls.conversationListEvent);
    socket?.off(AppUrls.updateConverstationEvent);
    super.dispose();
  }
}
