import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../core/constants/app_urls.dart';
import '../storage/user_preference.dart';


class SocketController extends ChangeNotifier {
  io.Socket? socket;

  String? subscribeSocketId;
  String? subscribeUserId;

  bool _isInitializing = false;
  bool _isGoingOnline = false;

  /// ==========================================================
  /// AUTO INITIALIZATION
  /// ==========================================================
  Future<void> ensureSocketReady() async {
    // Prevent multiple parallel initializations
    if (_isInitializing) return;
    _isInitializing = true;

    // 1️⃣ Create socket if null
    if (socket == null) {
      await _initSocketInternal();
    }

    // 2️⃣ Ensure socket is connected
    if (!(socket!.connected)) {
      socket!.connect();
      await _waitForConnect();
    }

    // 3️⃣ Ensure user is online
    await ensureOnline();

    _isInitializing = false;
  }

  /// INTERNAL: Build socket config and connect
  Future<void> _initSocketInternal() async {
    print('🔧 Initializing socket');

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
          .setReconnectionAttempts(999999999)   // infinite retry
          .setReconnectionDelay(2000)           // retry delay
          .setReconnectionDelayMax(5000)
          .setTimeout(15000)                    // connection timeout
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

    socket!.onConnect((_) {
      if (!completer.isCompleted) {
        print("🔌 Socket connected: ${socket!.id}");
        completer.complete();
      }
    });

    socket!.onConnectError((err) {
      if (!completer.isCompleted) {
        completer.completeError("Connection error: $err");
      }
    });

    return completer.future;
  }

  /// ==========================================================
  /// GO ONLINE AUTOMATION
  /// ==========================================================
  Future<void> ensureOnline() async {
    if (_isGoingOnline) return;
    _isGoingOnline = true;

    final userId = await UserPreference.returnUserId();
    if (userId == null) {
      print('No user ID → cannot go online');
      _isGoingOnline = false;
      return;
    }

    // Already online?
    if (socket!.id == subscribeSocketId && userId == subscribeUserId) {
      print("Already online. Skipping goOnline()");
      _isGoingOnline = false;
      return;
    }

    print("🌐 Going online...");
    final completer = Completer<void>();

    socket!.emit(AppUrls.goOnlineEvent, {"userId": userId});

    socket!.on(AppUrls.goOnlineEvent, (response) {
      socket!.off(AppUrls.goOnlineEvent);

      Map<String, dynamic> data =
      response is String ? jsonDecode(response) : response;

      if (data['status'] == true) {
        subscribeSocketId = socket!.id;
        subscribeUserId = userId;

        print("✅ Online success: $data");
        completer.complete();
      } else {
        print("❌ Online failed: $data");
        completer.completeError("Failed to go online");
      }
    });

    await completer.future;
    _isGoingOnline = false;
  }

  /// ==========================================================
  /// SEND MESSAGE (Fully Automated)
  /// ==========================================================
  Future<void> sendMessage(String event, Map<String, dynamic>? data) async {
    print("📤 Preparing to send message...");

    // AUTO-FIX everything before sending
    await ensureSocketReady();

    print("📤 Sending event $event => $data");
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

