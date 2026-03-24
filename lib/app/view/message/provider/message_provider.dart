import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/constants/app_urls.dart';
import '../../../data/models/chat_models/conversion_list_model.dart';
import '../../../data/network/web_socket_connection_service.dart';
import '../../../data/response/api_response.dart';
import '../../../data/storage/user_preference.dart';
import '../message_isolates/message_isolates.dart';

class MessageProvider extends ChangeNotifier {
  String? userId;
  final ScrollController scrollController = ScrollController();

  bool isLoading = false;
  int page = 1;
  bool isPagination = true;
  bool _listenersSetup = false;
  bool _disposed = false;

  ApiResponse<ConversionListModel> _allConversionData = ApiResponse.loading();
  ApiResponse<ConversionListModel> get allConversionData => _allConversionData;

  SocketController? _socket;
  SocketController? get socket =>
      _socket ??= navigatorKey.currentContext?.read<SocketController>();

  MessageProvider() {
    _init();
  }

  int get unreadChatCount {
    final list = allConversionData.data?.data ?? [];
    return list.fold<int>(0, (sum, chat) {
      final count = int.tryParse(chat.unreadMsgCount ?? '0') ?? 0;

      return sum + count;
    });
  }

  // ──────────────────────────────────────────────────────────────
  //  INITIALIZATION
  // ──────────────────────────────────────────────────────────────

  Future<void> _init() async {
    await _initUser();
    _socket = socket;
    _setupSocketLifecycleListeners();
    await _connectAndFetch();
    _startScrollListener();
  }

  Future<void> _initUser() async {
    userId = await UserPreference.returnUserId() ?? '';
  }

  // ──────────────────────────────────────────────────────────────
  //  SOCKET LIFECYCLE (connect / disconnect / reconnect)
  // ──────────────────────────────────────────────────────────────

  /// Sets up one-time listeners on the raw socket for connect, disconnect,
  /// reconnect, and error events. Safe to call multiple times – guards itself.
  void _setupSocketLifecycleListeners() {
    if (_listenersSetup || socket?.socket == null) return;
    _listenersSetup = true;

    final rawSocket = socket!.socket!;

    // On (re)connect  → go online & fetch conversations
    rawSocket.onConnect((_) {
      debugPrint('🔌 [MessageProvider] Socket connected (id: ${rawSocket.id})');
      if (!_disposed) {
        _onSocketConnected();
      }
    });

    // Disconnectm
    rawSocket.onDisconnect((_) {
      debugPrint('❌ [MessageProvider] Socket disconnected');
    });

    // Reconnect success
    rawSocket.on('reconnect', (_) {
      debugPrint('🔄 [MessageProvider] Socket reconnected');
      if (!_disposed) {
        _onSocketConnected();
      }
    });

    // Errors (for logging only — socket_io_client handles retry internally)
    rawSocket.onConnectError((err) {
      debugPrint('⚠️ [MessageProvider] Connect error: $err');
    });

    rawSocket.on('reconnect_error', (err) {
      debugPrint('⚠️ [MessageProvider] Reconnect error: $err');
    });

    rawSocket.onError((err) {
      debugPrint('⚠️ [MessageProvider] Socket error: $err');
    });
  }

  /// Called every time the socket (re)connects.
  /// Ensures the user goes online and then re-fetches conversation data.
  /// IMPORTANT: Do NOT use forceReconnect here — we just connected,
  /// forcing a reconnect would create an infinite loop.
  Future<void> _onSocketConnected() async {
    try {
      // Ensure the user is registered as "online" on the server
      await socket?.ensureOnline(force: true);
      // Fetch conversations from scratch (no forceReconnect!)
      await getAllConversions(true, forceReconnect: false, isRefresh: true);
    } catch (e) {
      debugPrint('❌ [MessageProvider] _onSocketConnected error: $e');
    }
  }

  /// Connects the socket (if not already) using SocketController's built-in
  /// logic and then fetches the initial conversation list.
  Future<void> _connectAndFetch() async {
    try {
      await socket?.ensureSocketReady();
      // If the socket was already connected before we set up our `onConnect`
      // listener, fetch data explicitly.
      if (socket?.isConnected == true) {
        await getAllConversions(true);
      }
    } catch (e) {
      debugPrint('❌ [MessageProvider] _connectAndFetch error: $e');
      updateAllConversionData(
        ApiResponse.error('Connection failed. Pull down to retry.'),
      );
    }
  }

  // ──────────────────────────────────────────────────────────────
  //  DATA HELPERS
  // ──────────────────────────────────────────────────────────────

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

  // ──────────────────────────────────────────────────────────────
  //  SCROLL / PAGINATION
  // ──────────────────────────────────────────────────────────────

  void _startScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading && isPagination) {
          getAllConversions(false);
        }
      }
    });
  }

  // ──────────────────────────────────────────────────────────────
  //  FETCH CONVERSATIONS
  // ──────────────────────────────────────────────────────────────

  /// [resetPage] — whether to reset pagination (page = 1)
  /// [forceReconnect] — only true on user-initiated pull-to-refresh.
  ///   Default follows resetPage for backward compat, but internal
  ///   callers (like _onSocketConnected) pass false explicitly.
  Future<void> getAllConversions(bool resetPage, {bool? forceReconnect, bool isRefresh = false}) async {
    if (isLoading) return;
    final shouldForceReconnect = forceReconnect ?? resetPage;

    try {
      if (userId == null || userId == '') await _initUser();

      if (resetPage) {
        if (!isRefresh) {
          updateAllConversionData(ApiResponse.loading());
        }
        page = 1;
        isPagination = true;
      }
      isLoading = true;

      socket?.off(AppUrls.conversationListEvent);
      final completer = Completer<void>();

      final timeoutTimer = Timer(const Duration(seconds: 15), () {
        if (!completer.isCompleted) {
          completer.completeError('Request timed out');
          socket?.off(AppUrls.conversationListEvent);
        }
      });

      socket?.listenToEvent(AppUrls.conversationListEvent, (p0) async {
        print('conversation list event: $p0');
        if (completer.isCompleted) return;
        timeoutTimer.cancel();
        socket?.off(AppUrls.conversationListEvent);

        if (!_isListeningToUpdates) _listenToConversationUpdates();

        if (p0 is Map<String, dynamic>) {
          final alldata = await parseConversationModelInBackground(p0);
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
        }
      });

      debugPrint('📤 Sending event conversation_list (page: $page)');
      // sendMessage internally calls ensureSocketReady — no need to call it separately
      await socket?.sendMessage(AppUrls.conversationListEvent, {
        'userId': userId ?? '',
        'page': page,
        'limit': 10,
      }, forceReconnect: shouldForceReconnect);

      await completer.future;
    } catch (e) {
      debugPrint('❌ [MessageProvider] getAllConversions error: $e');
      updateAllConversionData(ApiResponse.error(e.toString()));
      isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = navigatorKey.currentContext;
        if (context != null && Overlay.maybeOf(context) != null) {
          errorToast(context, 'Connection Timeout. Please retry.');
        }
      });
    }
  }

  // ──────────────────────────────────────────────────────────────
  //  REAL-TIME CONVERSATION UPDATES
  // ──────────────────────────────────────────────────────────────

  bool _isListeningToUpdates = false;

  void _listenToConversationUpdates() {
    _isListeningToUpdates = true;
    socket?.listenToEvent(AppUrls.updateConverstationEvent, (p0) async {
      print('updatedData: ${p0.to}');
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

  // ──────────────────────────────────────────────────────────────
  //  DISPOSE
  // ──────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _disposed = true;
    scrollController.dispose();
    socket?.off(AppUrls.conversationListEvent);
    socket?.off(AppUrls.updateConverstationEvent);
    // Remove lifecycle listeners we attached to the raw socket
    socket?.socket?.off('connect');
    socket?.socket?.off('disconnect');
    socket?.socket?.off('reconnect');
    socket?.socket?.off('connect_error');
    socket?.socket?.off('reconnect_error');
    socket?.socket?.off('error');
    super.dispose();
  }
}
