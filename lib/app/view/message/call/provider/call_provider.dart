// import 'dart:async';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:g_clout_media/core/appExports/app_export.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../../../../../core/network/web_socket_connection_service.dart';
//
// class CallProvider extends ChangeNotifier {
//
//   String? callId;
//   String? uuid;
//
//   bool _isInitialized = false;
//   bool get isInitialized => _isInitialized;
//   updateIsInitialized(bool value){
//     _isInitialized = value;
//     notifyListeners();
//   }
//
//   String callingStatus = "Calling...";
//
//
//   String callType = "audio"; // default
//
//   setCallType(String type) {
//     callType = type;
//   }
//
//
//   // AUTO END AFTER 25 SEC
//
//
//   init(String conversionId,String calltype) {
//     _isMuted = false;
//     _isSpeakerOn = false;
//     startCall(conversionId,calltype);
//   }
//
//   bool _isMuted = false;
//   bool _isSpeakerOn = false;
//
//   bool get isMuted => _isMuted;
//   bool get isSpeakerOn => _isSpeakerOn;
//
//
//
//
//
//
//   callClose(BuildContext context){
//     FlutterCallkitIncoming.endCall(uuid??Uuid().v4());
//     FlutterCallkitIncoming.endAllCalls();
//     Navigator.pop(context);
//   }
//
//
//   String? agoraAppId ;
//   String? agoraToken ;
//
//   String? userId;
//
//   Future<void> getUserId() async {
//     userId = await UserPreference.returnUserId() ?? '';
//   }
//
//   SocketController socket = navigatorKey.currentContext!.read<SocketController>();
//
//   List<int> _remoteUid = [];
//   List<int> get remoteUid => _remoteUid;
//   addRemoveUid(int? value){
//     if(value==null) return;
//     _remoteUid.add(value);
//     notifyListeners();
//   }
//
//
//   Future<void> startCall(String conversionId,String calltype) async {
//     await getUserId();
//
//     // Send the call request
//     socket.sendMessage(AppUrls.requestCallEvent, {
//       "converstaionId": conversionId,
//       "senderId": userId,
//       "callType": calltype,
//     });
//
//     // Timeout duration (example: 10 seconds)
//     const timeout = Duration(seconds: 10);
//
//     bool responseReceived = false;
//
//     // Start timeout timer
//     Timer(timeout, () {
//       if (!responseReceived) {
//         print("❌ No response from server, ending call...");
//         // Add your call-close logic here
//         callClose(navigatorKey.currentContext!);
//       }
//     });
//
//     // Listen for incoming event
//     socket.listenToEvent(AppUrls.requestCallEvent, (p0) async {
//       responseReceived = true;
//       socket.off(AppUrls.requestCallEvent);
//
//       if (p0 is String) {
//         final data = jsonDecode(p0);
//         if (kDebugMode) {
//           print("data string is $data");
//         }
//         return;
//       }
//
//       if (p0 is Map) {
//         final data = p0 as Map<String, dynamic>;
//         print('data is $data');
//         if(data['status']==true){
//           callId = data['data']['callId'];
//           initAgora(
//             data['data']['appId'],
//             data['data']['token'],
//             data['data']['channelName'],
//             navigatorKey.currentContext!,
//             true,
//           );
//         }else{
//           endCall(navigatorKey.currentContext!);
//           Get.showToast(data['message'], type: ToastType.error);
//         }
//       }
//     });
//   }
//
//
//   late RtcEngine agoraEngine;
//
//   Timer? callTimer;
//   Duration callDuration = Duration.zero;
//
//   Timer? timeoutTimer;
//   final Duration callTimeout = Duration(seconds: 45);
//
//   void startTimeoutTimer(mounted,BuildContext context) {
//     timeoutTimer = Timer(callTimeout, () {
//       if (mounted) {
//         callingStatus = "No Answer";
//         notifyListeners();
//         endCall(context);
//       }
//     });
//   }
//
//   String channelid = '0';
//
//
//   Future<void> initAgora(
//       String appId,
//       String token,
//       String channelId,
//       BuildContext context,
//       bool isOutgoing,
//       ) async {
//     channelid = channelId;
//
//     await Permission.microphone.request();
//     await Permission.camera.request(); // 👈 for video calls
//
//     agoraEngine = createAgoraRtcEngine();
//
//     await agoraEngine.initialize(RtcEngineContext(appId: appId));
//
//
//
//     // Register event handlers (same as before)
//     agoraEngine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (connection, elapsed) {
//           callingStatus = callType == "video" ? "Connecting Video..." : "Ringing...";
//           notifyListeners();
//         },
//         onUserJoined: (connection, remoteUid, elapsed) {
//           addRemoveUid(remoteUid);
//           timeoutTimer?.cancel();
//           startCallTimer();
//           callingStatus = "Connected";
//           notifyListeners();
//         },
//         onUserOffline: (connection, remoteUid, reason) {
//           // callClose(context);
//         },
//         onError: (err, msg) {
//           callClose(context);
//         },
//       ),
//     );
//
//     // AUDIO ALWAYS ON
//     await agoraEngine.enableAudio();
//
//     // VIDEO ONLY IF callType == "video"
//     if (callType == "video") {
//       await agoraEngine.enableVideo();
//       await agoraEngine.startPreview();
//     }
//
//     await agoraEngine.setChannelProfile(ChannelProfileType.channelProfileCommunication);
//     await agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//
//     await agoraEngine.joinChannel(
//       token: token,
//       channelId: channelId,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//     updateIsInitialized(true);
//   }
//
//
//
//   // Future<void> initAgora(String appId,String token,String channelId,BuildContext context,bool isOutgoing) async {
//   //   await Permission.microphone.request();
//   //
//   //   print("AGORA APP ID: $appId");
//   //   print("AGORA TOKEN: $token");
//   //   print("AGORA CHANNEL ID: $channelId");
//   //
//   //
//   //
//   //
//   //
//   //   agoraEngine = createAgoraRtcEngine();
//   //
//   //   await agoraEngine.initialize(
//   //     RtcEngineContext(appId: appId),
//   //   );
//   //
//   //   agoraEngine.registerEventHandler(
//   //     RtcEngineEventHandler(
//   //       onJoinChannelSuccess: (connection, elapsed) {
//   //         print("LOCAL USER JOINED");
//   //         callingStatus = "Ringing...";
//   //         notifyListeners();
//   //       },
//   //       onUserJoined: (connection, remoteUid, elapsed) {
//   //         print("REMOTE USER JOINED");
//   //
//   //         timeoutTimer?.cancel();        // 🛑 Stop auto-timeout
//   //         startCallTimer();              // ▶ Start call duration
//   //
//   //         callingStatus = "Connected";
//   //         notifyListeners();
//   //       },
//   //
//   //       // onUserJoined: (connection, remoteUid, elapsed) {
//   //       //   callProvider.callingStatus = "Connected";
//   //       //   callProvider.notifyListeners();
//   //       // },
//   //       onUserOffline: (connection, remoteUid, reason) {
//   //         print("REMOTE USER LEFT");
//   //         callClose(context);
//   //       },
//   //         onError: (ErrorCodeType err, String msg) {
//   //           print("❌ AGORA ERROR OCCURRED:");
//   //           print("Error Code: $err");
//   //           print("Message: $msg");
//   //           callClose(context);
//   //         }
//   //
//   //     ),
//   //   );
//   //
//   //   await agoraEngine.enableAudio();
//   //   await agoraEngine.setChannelProfile(
//   //     ChannelProfileType.channelProfileCommunication,
//   //   );
//   //   await agoraEngine.setClientRole(
//   //     role: ClientRoleType.clientRoleBroadcaster,
//   //   );
//   //
//   //   await agoraEngine.joinChannel(
//   //     token: token??'',
//   //     channelId: channelId,
//   //     uid: 0,
//   //     options: const ChannelMediaOptions(),
//   //   );
//   // }
//
//
//   Future<void> acceptCall(String? callid) async {
//
//     // Send the call request
//     socket.sendMessage(AppUrls.acceptCallEvent, {
//       "callId":callid
//     });
//
//
//     // Listen for incoming event
//     socket.listenToEvent(AppUrls.acceptCallEvent, (p0) async {
//       socket.off(AppUrls.acceptCallEvent);
//       if (p0 is String) {
//         final data = jsonDecode(p0);
//         if (kDebugMode) {
//           print("data string is $data");
//         }
//         return;
//       }
//       if (p0 is Map) {
//         final data = p0 as Map<String, dynamic>;
//         print('data is $data');
//       }
//     });
//   }
//
//
//   Future<void> checkCallStatus(String? callid) async {
//
//     // Send the call request
//     socket.sendMessage(AppUrls.checkCallStatusEvent, {
//       "callId":callid
//     });
//
//
//     // Listen for incoming event
//     socket.listenToEvent(AppUrls.checkCallStatusEvent, (p0) async {
//       socket.off(AppUrls.checkCallStatusEvent);
//       if (p0 is String) {
//         final data = jsonDecode(p0);
//         if (kDebugMode) {
//           print("data string is $data");
//         }
//         return;
//       }
//       if (p0 is Map) {
//         final data = p0 as Map<String, dynamic>;
//         if(data['status']==true){
//           if(!(data['data']['status']=='pending' || data['data']['status']=='busy')){
//             endCall(navigatorKey.currentContext!);
//           }
//         }
//       }
//     });
//   }
//
//   Future<void> rejectCall() async {
//
//     // Send the call request
//     socket.sendMessage(AppUrls.rejectCallEvent, {
//       "callId":callId
//     });
//
//
//     // Listen for incoming event
//     socket.listenToEvent(AppUrls.rejectCallEvent, (p0) async {
//       socket.off(AppUrls.rejectCallEvent);
//       if (p0 is String) {
//         final data = jsonDecode(p0);
//         if (kDebugMode) {
//           print("data string is $data");
//         }
//         return;
//       }
//       if (p0 is Map) {
//         final data = p0 as Map<String, dynamic>;
//         print('data is $data');
//       }
//     });
//   }
//
//
//
//   // --------------------------------------------------------------
//   // 🔥 TOGGLE MUTE
//   // --------------------------------------------------------------
//   void toggleMute() {
//     _isMuted = !_isMuted;
//     agoraEngine.muteLocalAudioStream(isMuted);
//   }
//
//   // --------------------------------------------------------------
//   // 🔥 TOGGLE SPEAKER
//   // --------------------------------------------------------------
//   void toggleSpeaker() {
//     _isSpeakerOn = !_isSpeakerOn;
//     agoraEngine.setEnableSpeakerphone(isSpeakerOn);
//   }
//
//   // --------------------------------------------------------------
//   // 🔥 END CALL
//   // --------------------------------------------------------------
//   void endCall(BuildContext context) {
//     try{
//       rejectCall();
//       callTimer?.cancel();
//       timeoutTimer?.cancel();
//       agoraEngine.leaveChannel();
//       callClose(context);
//     }catch(e){
//       callClose(context);
//     }
//
//   }
//
//
//   void startCallTimer() {
//     callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       callDuration += const Duration(seconds: 1);
//       notifyListeners();
//     });
//   }
//
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     callTimer?.cancel();
//     super.dispose();
//   }
//
//
// }
