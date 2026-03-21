import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../core/appExports/app_export.dart';
import '../../core/constants/app_urls.dart';
import '../storage/user_preference.dart';

class SocketController extends ChangeNotifier {
  io.Socket? socket;

  String? subscribeSocketId;
  String? subscribeUserId;

  bool get isConnected => socket != null && socket!.connected;

  Future<void>? _readyFuture;

  /// ==========================================================
  /// AUTO INITIALIZATION
  /// ==========================================================
  Future<void> ensureSocketReady({bool forceReconnect = false}) async {
    // If already in progress and not forcing, return the same future
    if (_readyFuture != null && !forceReconnect) return _readyFuture!;

    _readyFuture = _ensureSocketReadyInternal(forceReconnect: forceReconnect);
    try {
      return await _readyFuture!;
    } finally {
      _readyFuture = null;
    }
  }

  Future<void> _ensureSocketReadyInternal({bool forceReconnect = false}) async {
    try {
      if (forceReconnect && socket != null) {
        if (kDebugMode) print('🔄 Forcing socket reconnect...');
        socket!.disconnect();
        await Future.delayed(const Duration(milliseconds: 300));
        subscribeSocketId = null;
        subscribeUserId = null;
      }

      // 1️⃣ Create socket if null
      if (socket == null) {
        await _initSocketInternal();
      }

      // 2️⃣ Ensure socket is connected
      if (!(socket!.connected)) {
        if (kDebugMode) print('🔌 Socket not connected, connecting...');
        socket!.connect();
        await _waitForConnect().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception("Socket connection timeout"),
        );
      }

      // 3️⃣ Ensure user is online
      await ensureOnline(force: forceReconnect);
    } catch (e) {
      if (kDebugMode) print('❌ Error in ensureSocketReady: $e');
      rethrow;
    }
  }

  /// INTERNAL: Build socket config and connect
  Future<void> _initSocketInternal() async {
    if (kDebugMode) {
      print('🔧 Initializing socket');
    }

    // socket = io.io(
    //   AppUrls.baseUrlSocket,
    //   io.OptionBuilder()
    //       .enableAutoConnect()
    //       .setTransports(['websocket'])
    //       .enableReconnection()
    //       .setReconnectionAttempts(5)
    //       .setTimeout(7000)
    //       .build(),
    // );

    socket = io.io(
      AppUrls.baseUrlSocket,
      io.OptionBuilder()
          .enableAutoConnect()
          .setTransports(['websocket'])
          .enableReconnection()
          .setReconnectionAttempts(999999999) // infinite retry
          .setReconnectionDelay(2000) // retry delay
          .setReconnectionDelayMax(5000)
          .setTimeout(15000) // connection timeout
          .build(),
    );

    // Immediate connect
    socket!.connect();
  }

  /// ==========================================================
  /// WAIT FOR CONNECTION
  /// ==========================================================
  Future<void> _waitForConnect() {
    final completer = Completer<void>();

    // Clear old listeners for these specific events to avoid piling them up
    socket!.off('connect');
    socket!.off('connect_error');

    socket!.onConnect((_) {
      if (!completer.isCompleted) {
        if (kDebugMode) {
          print("🔌 Socket connected successfully: ${socket!.id}");
        }
        completer.complete();
      }
    });

    socket!.onConnectError((err) {
      if (kDebugMode) {
        print("❌ Socket connection error detail: $err");
      }
      if (!completer.isCompleted) {
        completer.completeError("Connection error: $err");
      }
    });

    return completer.future;
  }

  Future<void>? _onlineFuture;

  /// ==========================================================
  /// GO ONLINE AUTOMATION
  /// ==========================================================
  Future<void> ensureOnline({bool force = false}) async {
    // Use existing future if one is in flight and we aren't forcing
    if (_onlineFuture != null && !force) return _onlineFuture!;

    _onlineFuture = _ensureOnlineInternal(force: force);
    try {
      return await _onlineFuture!;
    } finally {
      _onlineFuture = null;
    }
  }

  Future<void> _ensureOnlineInternal({bool force = false}) async {
    try {
      final userId = await UserPreference.returnUserId();
      if (userId == null) {
        if (kDebugMode) print('No user ID → cannot go online');
        return;
      }

      // Already online? (unless forced)
      if (!force &&
          socket!.id == subscribeSocketId &&
          userId == subscribeUserId) {
        if (kDebugMode) print("Already online. Skipping goOnline()");
        return;
      }

      if (kDebugMode) print("🌐 Going online...");

      final completer = Completer<void>();

      // Register listener first
      socket!.off(AppUrls.goOnlineEvent);
      socket!.on(AppUrls.goOnlineEvent, (response) {
        if (completer.isCompleted) return;

        Map<String, dynamic> data =
            response is String ? jsonDecode(response) : response;

        if (data['status'] == true) {
          subscribeSocketId = socket!.id;
          subscribeUserId = userId;
          if (kDebugMode) print("✅ Online success: $data");
          completer.complete();
        } else {
          if (kDebugMode) print("❌ Online failed: $data");
          completer.completeError("Failed to go online");
        }
      });

      // Send event
      socket!.emit(AppUrls.goOnlineEvent, {"userId": userId});

      // Wait for response
      await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          socket!.off(AppUrls.goOnlineEvent);
          throw Exception("goOnline status timeout");
        },
      );
    } catch (e) {
      if (kDebugMode) print('❌ Error in ensureOnline: $e');
      rethrow;
    } finally {
      socket!.off(AppUrls.goOnlineEvent);
    }
  }

  /// ==========================================================
  /// SEND MESSAGE (Fully Automated)
  /// ==========================================================
  Future<void> sendMessage(
    String event,
    Map<String, dynamic>? data, {
    bool forceReconnect = false,
  }) async {
    if (kDebugMode) {
      print("📤 Preparing to send message...");
    }

    // AUTO-FIX everything before sending
    await ensureSocketReady(forceReconnect: forceReconnect);

    if (kDebugMode) {
      print("📤 Sending event $event => $data");
    }
    socket!.emit(event, data);
  }

  /// ==========================================================
  /// LISTENER
  /// ==========================================================
  void listenToEvent(String event, Function(dynamic) callback) {
    socket?.on(event, callback);
  }

  void off(String event) {
    socket?.off(event);
  }

  @override
  void dispose() {
    socket?.disconnect();
    socket?.dispose();
    super.dispose();
  }
}



// class SocketController extends ChangeNotifier {
//   late io.Socket socket;
//
//   String? subscribeSocketId;
//   String? subscribeUserId;
//
//   void initSocket() {
//     print('socket controller initialized');
//     socket = io.io(
//       AppUrls.baseUrlSocket,
//       io.OptionBuilder()
//           .enableAutoConnect()
//           .setTransports(['websocket'])
//           .enableReconnection()
//           .setReconnectionAttempts(5)   // Optional
//           .setTimeout(7000)              // <-- socket.io internal timeout
//           .build(),
//       // io.OptionBuilder()
//       //     .enableAutoConnect()
//       //     .setTransports(['websocket',])
//       //     .enableReconnection()
//       //     .build(),
//     );
//
//     socket.connect();
//
//     socket.onConnect((_) {
//       if (kDebugMode) {
//         print(socket.id);
//         print('🔌 Socket connected');
//       }
//       goOnline();
//     });
//
//     socket.onDisconnect((_) {
//       if (kDebugMode) {
//         print('❌ Socket disconnected');
//       }
//       socket.connect();
//     });
//
//     socket.onConnectError((error) {
//       print("❌ Connect Error: $error");
//     });
//
//     // socket.((data) {
//     //   print("⏳ Connect Timeout: $data");
//     // });
//
//     // ❌ Any other socket error
//     socket.onError((error) {
//       print("⚠️ Socket Error: $error");
//     });
//
//     // ❌ Reconnect failure
//     socket.onReconnectError((error) {
//       print("🔄 Reconnect Error: $error");
//     });
//
//     // Example event listener
//     socket.on('message', (data) {
//       if (kDebugMode) {
//         print('📩 New message: $data');
//       }
//     });
//   }
//
//   Future<void> goOnline() async {
//     String? userId = await UserPreference.returnUserId();
//
//     print('Socket ID: ${socket.id},${socket}, Subscribe Socket ID: $subscribeSocketId');
//     if(socket.id==null){
//       try{
//         socket.connect();
//       }catch(e){
//         if (kDebugMode) {
//           print('Error connecting socket: $e');
//         }
//       }
//
//     }
//
//     if(!(socket.id != subscribeSocketId || userId != subscribeUserId)){
//       if (kDebugMode) {
//         print('already online, skipping goOnline');
//       }
//       return;
//     }
//
//     if (kDebugMode) {
//       print('Socket is not online or userId mismatch, connecting...');
//     }
//
//     // If userId is null, don't proceed
//     if (userId == null) {
//       if (kDebugMode) {
//         print('User ID is null, skipping goOnline');
//       }
//       return;
//     }
//
//     // Create a Completer to await the socket response
//     Completer<void> completer = Completer<void>();
//
//     // Emit the goOnline event
//     socket.emit(AppUrls.goOnlineEvent, {"userId": userId});
//
//     // Listen for the response from the goOnline event
//     listenToEvent(AppUrls.goOnlineEvent, (p0) {
//       socket.off(AppUrls.goOnlineEvent);
//
//       if (p0 is String) {
//         final data = jsonDecode(p0);
//         if (kDebugMode) {
//           print("Online Status: $data");
//         }
//       } else if (p0 is Map) {
//         final data = p0 as Map<String, dynamic>;
//         if (data['status'] == true) {
//           // Success: Set the socket ID and user ID
//           subscribeSocketId = socket.id;
//           subscribeUserId = userId;
//                   // navigatorKey.currentContext!
//                   //     .read<MessageProvider>()
//                   //     .getAllConversions(true);
//           if (kDebugMode) {
//             print("Online Status: $data");
//           }
//
//           completer.complete();  // Mark the completer as complete (resolve the future)
//         } else {
//           if (kDebugMode) {
//             print('Failed to go online: $data');
//           }
//           completer.completeError('Failed to go online');  // Resolve with error
//         }
//       }
//     });
//
//     // Await the completer (wait for the socket response)
//     await completer.future;  // This will wait until completer.complete() is called
//   }
//
//
//   // Future<void> goOnline() async {
//   //   String? userId = await UserPreference.returnUserId();
//   //
//   //   // If userId is null, don't proceed
//   //   if (userId == null) {
//   //     if (kDebugMode) {
//   //       print('User ID is null, skipping goOnline');
//   //     }
//   //     return;
//   //   }
//   //
//   //   socket.emit(AppUrls.goOnlineEvent, {"userId": userId});
//   //
//   //   listenToEvent(AppUrls.goOnlineEvent, (p0) {
//   //     socket.off(AppUrls.goOnlineEvent);
//   //     if (p0 is String) {
//   //       final data = jsonDecode(p0);
//   //       // Handle data if needed
//   //       if (kDebugMode) {
//   //         print("Online Status: $data");
//   //       }
//   //     } else if (p0 is Map) {
//   //       final data = p0 as Map<String, dynamic>;
//   //       if (data['status'] == true) {
//   //         navigatorKey.currentContext!
//   //             .read<MessageProvider>()
//   //             .getAllConversions(true);
//   //       }
//   //       subscribeSocketId = socket.id;
//   //       subscribeUserId = userId;
//   //       if (kDebugMode) {
//   //         print("Online Status: $data");
//   //       }
//   //     }
//   //   });
//   // }
//
//   Future<void> sendMessage(String event, Map<String, dynamic>? data) async {
//
//     if(socket==null){
//       await initSocket();
//     }
//
//     if (kDebugMode) {
//       log(socket.connected.toString(), name: "socket connect status");
//       log(socket.id.toString(), name: "socket connect id ");
//     }
//
//     String? userId = await UserPreference.returnUserId();
//     if (userId == null) {
//       if (kDebugMode) {
//         print('Cannot send message: User ID is null');
//       }
//       return;  // Don't send the message if userId is null
//     }
//
//     // Ensure we're not sending messages unless the socket is properly connected and we are online
//     if (socket.id != subscribeSocketId || userId != subscribeUserId) {
//       if (kDebugMode) {
//         print('Socket is not online or userId mismatch, connecting...');
//       }
//       if(socket.id==null){
//         socket.connect();
//       }
//       // Wait for goOnline to complete before sending the message
//       await goOnline();  // Ensure goOnline completes
//     }
//
//     if (kDebugMode) {
//       log(socket.connected.toString(), name: "socket connect status");
//       log(socket.id.toString(), name: "socket connect id ");
//     }
//
//     if (kDebugMode) {
//       print('📤 Sending message: $event --- $data');
//     }
//
//     socket.emit(event, data);
//   }
//
//   void listenToEvent(String event, Function(dynamic) callback) {
//     socket.on(event, callback);
//   }
//
//   void off(String event) {
//     socket.off(event);
//   }
//
//   @override
//   void dispose() {
//     socket.disconnect();
//     socket.dispose();
//     super.dispose();
//   }
// }


// class SocketController extends ChangeNotifier {
//   late io.Socket socket;
//
//   String? subscribeSocketId;
//   String? subscribeUserId;
//
//   void initSocket() {
//     print('socket controller initialized');
//     socket = io.io(
//       AppUrls.baseUrlSocket,
//       io.OptionBuilder()
//           .enableAutoConnect()
//           .setTransports(['websocket',])
//           .enableReconnection()
//           .build(),
//     );
//
//     socket.connect();
//
//     socket.onConnect((_) {
//
//       if (kDebugMode) {
//         print(socket.id);
//         print('🔌 Socket connected');
//       }
//     });
//
//     socket.onDisconnect((_) {
//       if (kDebugMode) {
//         print('❌ Socket disconnected');
//       }
//     });
//
//     // Example event listener
//     socket.on('message', (data) {
//       if (kDebugMode) {
//         print('📩 New message: $data');
//       }
//     });
//   }
//
//
//   Future<void> goOnline() async {
//     String? userId =  await UserPreference.returnUserId();
//     sendMessage(AppUrls.goOnlineEvent, {"userId": userId ?? ''});
//
//     listenToEvent(AppUrls.goOnlineEvent, (p0) {
//       socket.off(AppUrls.goOnlineEvent);
//       if (p0 is String) {
//         final data = jsonDecode(p0);
//         // use data['key']
//         if (kDebugMode) {
//           print("Online Status $data");
//         }
//       } else if (p0 is Map) {
//         final data = p0 as Map<String, dynamic>;
//         if (data['status'] == true) {
//           navigatorKey.currentContext!
//               .read<MessageProvider>()
//               .getAllConversions(true);
//         }
//         subscribeSocketId = socket.id;
//         subscribeUserId = userId;
//         if (kDebugMode) {
//           print("Online Status $data");
//         }
//       }
//     });
//   }
//
//
//   Future<void> sendMessage(String event, Map<String, dynamic>? data) async {
//
//     if(kDebugMode){
//       log(socket.connected.toString() , name: "socket connect status");
//       log(socket.id.toString() , name: "socket connect id ");
//     }
//     String? userId = await UserPreference.returnUserId();
//     if(userId!=null&&(socket.id!=subscribeSocketId||userId!=subscribeUserId)){
//       socket.connect();
//       goOnline();
//     }
//     if(kDebugMode){
//       log(socket.connected.toString() , name: "socket connect status");
//       log(socket.id.toString() , name: "socket connect id ");
//     }
//     if (kDebugMode) {
//       print('📤 Sending message: $event --- ${data}');
//     }
//     socket.emit(event,data);
//   }
//
//   void listenToEvent(String event, Function(dynamic) callback) {
//     socket.on(event, callback);
//   }
//
//   void off(String event) {socket.off(event);}
//
//   @override
//   void dispose() {
//     socket.disconnect();
//     socket.dispose();
//     super.dispose();
//   }
// }

