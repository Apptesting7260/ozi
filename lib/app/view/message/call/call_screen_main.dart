//
// import 'package:g_clout_media/presentation/dashboard/presentation/message/call/provider/call_provider.dart';
//
// import '../../../../../../core/appExports/app_export.dart';
// import '../../../../../Custom/widgets/custom_circular_image_widget.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
//
//
// class RingingCallCard extends StatefulWidget {
//   const RingingCallCard({
//     super.key,
//      this.conversationId,
//      this.callId,
//     required this.userName,
//     required this.userImageUrl, this.appId, this.token, this.channelName, required this.callType, this.uuid,
//   });
//
//   final String? conversationId;
//   final String? callId;
//   final String? uuid;
//   final String userName;
//   final String callType;
//   final String userImageUrl;
//   final String? appId;
//   final String? token;
//   final String? channelName;
//
//   @override
//   State<RingingCallCard> createState() => _RingingCallCardState();
// }
//
// class _RingingCallCardState extends State<RingingCallCard>
//     with SingleTickerProviderStateMixin {
//
//
//   late AnimationController _controller;
//   CallProvider callProvider = CallProvider();
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     callProvider.callId = widget.callId;
//     callProvider.uuid = widget.uuid;
//     callProvider.setCallType(widget.callType);
//     if(widget.conversationId!=null){
//       callProvider.init(widget.conversationId??'',widget.callType);
//       callProvider.startTimeoutTimer(mounted,context);
//     }else{
//       callProvider.callingStatus = 'Connecting...';
//       callProvider.acceptCall(widget.callId);
//       callProvider.checkCallStatus(widget.callId);
//       callProvider.initAgora(widget.appId??'',widget.token??'',widget.channelName??'',navigatorKey.currentContext!,false);
//     }
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     )..repeat();
//   }
//
//
//   Widget _buildAudioCallUI() {
//     return Consumer<CallProvider>(
//       builder: (context, value, child) {
//         return Column(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   MessageScreen.adsWidget,
//                   hBox(70),
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       _buildAnimatedRings(),
//                       CircularProfileImage(
//                         imageUrl: widget.userImageUrl,
//                         borderColor: Colors.transparent,
//                         size: 140,
//                       ),
//                     ],
//                   ),
//                   hBox(30),
//                   Text(
//                     widget.userName,
//                     style: AppFontStyle.text_28_500(context.white),
//                   ),
//
//                   Text(
//                     "conv ${widget.conversationId} //appId ${widget.appId}// cannel ${widget.channelName} //token ${widget.token}",
//                     style: AppFontStyle.text_8_400(context.white),
//                     maxLines: 20,
//                   ),
//                   hBox(20),
//                   // Text(
//                   //   value.callingStatus,
//                   //   style: AppFontStyle.text_22_400(context.white),
//                   // ),
//                   Column(
//                     children: [
//                       Text(
//                         value.callingStatus,
//                         style: AppFontStyle.text_22_400(context.white),
//                       ),
//                       if (value.callingStatus == "Connected") ...[
//                         hBox(6),
//                         Text(
//                           _formatTime(value.callDuration),
//                           style: AppFontStyle.text_20_400(context.white),
//                         ),
//                       ]
//                     ],
//                   )
//
//                 ],
//               ),
//             ),
//             _buildInputBar(context),
//           ],
//         );
//       },
//     );
//   }
//
//
//
//
//
//   @override
//   void dispose() {
//     callProvider.agoraEngine.leaveChannel();
//     callProvider.agoraEngine.release();
//     callProvider.callClose(context);
//     _controller.dispose();
//     super.dispose();
//   }
//
//   // --------------------------------------------------------------
//   // 🔥 INIT AGORA (AppId + Token from PROVIDER)
//   // --------------------------------------------------------------
//
//
//
//
//
//
//   // --------------------------------------------------------------
//   // UI (unchanged except button actions)
//   // --------------------------------------------------------------
//
//   String capitalize(String s) {
//     if (s.isEmpty) return s;
//     return s[0].toUpperCase() + s.substring(1);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async{
//         callProvider.endCall(context);
//         return false;
//       },
//       child: ChangeNotifierProvider.value(
//         value: callProvider,
//         child: Consumer<CallProvider>(
//           builder: (context, value, child) {
//             return Scaffold(
//               backgroundColor: context.primary,
//               appBar: AppBar(
//                 scrolledUnderElevation: 0,
//                 backgroundColor: context.primary,
//                 centerTitle: true,
//                 leading: const SizedBox(),
//                 title: Text(
//                   "${capitalize(widget.callType)} Call with ${widget.userName}",
//                   style: AppFontStyle.text_18_400(context.white),
//                 ),
//               ),
//               body: value.isInitialized==false? _buildAudioCallUI() :widget.callType == "video"
//                   ? _buildVideoCallUI()
//                   : _buildAudioCallUI(),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   String _formatTime(Duration d) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
//   }
//
//   Widget _buildVideoCallUI() {
//     return Stack(
//       children: [
//         // REMOTE VIDEO
//         Center(
//           child:
//           RemoteVideoListView(
//             rtcEngine: callProvider.agoraEngine,
//             channelId: widget.channelName ?? callProvider.channelid,
//             remoteUids: callProvider.remoteUid,   // your list of uids
//           )
//           // AgoraVideoView(
//           //   controller: VideoViewController.remote(
//           //     rtcEngine: callProvider.agoraEngine,
//           //     canvas:  VideoCanvas(uid: callProvider.remoteUid??1),
//           //     connection: RtcConnection(
//           //       channelId: widget.channelName??callProvider.channelid,
//           //     ),
//           //   ),
//           // ),
//         ),
//
//         // LOCAL SMALL PREVIEW
//         MovableLocalPreview(rtcEngine: callProvider.agoraEngine),
//         // Positioned(
//         //   right: 16,
//         //   top: 120,
//         //   child: SizedBox(
//         //     width: 120,
//         //     height: 160,
//         //     child: AgoraVideoView(
//         //       controller: VideoViewController(
//         //         rtcEngine: callProvider.agoraEngine,
//         //         canvas: const VideoCanvas(uid: 0),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//
//         // CALL CONTROLS
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: _buildVideoControls(),
//         )
//       ],
//     );
//   }
//
//   Widget _buildVideoControls() {
//     return Consumer<CallProvider>(
//       builder: (context, value, child) {
//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _circleButton(Colors.white,callProvider.isMuted?ImageConstants.micIconOff:ImageConstants.micIcon,onTap: callProvider.toggleMute),
//               _circleButton(Colors.white, ImageConstants.cameraFlipIcon,
//                 iconColor: Colors.black,
//                 onTap: () {
//                   callProvider.agoraEngine.switchCamera();
//                 },
//               ),
//               _circleButton(context.redBackground, ImageConstants.flatCallIcon,
//                 iconColor: Colors.white,
//                 onTap: () => callProvider.endCall(context),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
//
//   Widget _buildInputBar(BuildContext context) {
//     return Consumer<CallProvider>(
//         builder: (context, value, child) {
//           return Container(
//             width: double.infinity,
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.only(left: 15, right: 7),
//                   margin:
//                   const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       InkWell(
//                         onTap: value.toggleMute,
//                         child: _circleButton(
//                           Colors.white,
//                           value.isMuted
//                               ? ImageConstants.micIconOff
//                               : ImageConstants.micIcon,
//                         ),
//                       ),
//                       InkWell(
//                         onTap: value.toggleSpeaker,
//                         child: _circleButton(
//                           Colors.white,
//                           value.isSpeakerOn
//                               ? ImageConstants.speakerIcon
//                               : ImageConstants.speakerIconOff,
//                           margin:
//                           const EdgeInsets.symmetric(horizontal: 10),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () => value.endCall(context),
//                         child: _circleButton(
//                           context.redBackground,
//                           ImageConstants.flatCallIcon,
//                           iconColor: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
//
//
//   Widget _circleButton(
//     Color bgColor,
//     String iconPath, {
//     EdgeInsets margin = EdgeInsets.zero,
//     Color? iconColor,
//     void Function()? onTap
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: 60,
//         height: 60,
//         margin: margin,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(100),
//         ),
//         child: Center(
//           child: CustomImage(
//             height: 30,
//             width: 30,
//             path: iconPath,
//             color: iconColor,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPulsingRing(double delay) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final value = (_controller.value + delay) % 1.0;
//         final scale = 1.0 + (value * 1.5);
//         final opacity = (1.0 - value).clamp(0.0, 1.0);
//
//         return Opacity(
//           opacity: opacity * 0.4,
//           child: Transform.scale(
//             scale: scale,
//             child: Container(
//               width: 140,
//               height: 140,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: context.white, width: 17),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildAnimatedRings() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         _buildPulsingRing(0.0),
//         _buildPulsingRing(0.33),
//         _buildPulsingRing(0.66),
//       ],
//     );
//   }
//
// }
//
//
// class MovableLocalPreview extends StatefulWidget {
//   final RtcEngine rtcEngine;
//
//   const MovableLocalPreview({super.key, required this.rtcEngine});
//
//   @override
//   State<MovableLocalPreview> createState() => _MovableLocalPreviewState();
// }
//
// class _MovableLocalPreviewState extends State<MovableLocalPreview> {
//   double posX = 20;
//   double posY = 120;
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: posX,
//       top: posY,
//       child: GestureDetector(
//         onPanUpdate: (details) {
//           setState(() {
//             posX += details.delta.dx;
//             posY += details.delta.dy;
//           });
//         },
//         child: SizedBox(
//           width: 120,
//           height: 160,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: AgoraVideoView(
//               controller: VideoViewController(
//                 rtcEngine: widget.rtcEngine,
//                 canvas: const VideoCanvas(uid: 0),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class RemoteVideoListView extends StatelessWidget {
//   final RtcEngine rtcEngine;
//   final String channelId;
//   final List<int> remoteUids;
//
//   const RemoteVideoListView({
//     super.key,
//     required this.rtcEngine,
//     required this.channelId,
//     required this.remoteUids,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final count = remoteUids.length;
//
//     if (count == 0) {
//       return const Center(child: Text("No remote users yet"));
//     }
//
//     // ---- 1 USER → FULL SCREEN ----
//     if (count == 1) {
//       final uid = remoteUids.first;
//
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: rtcEngine,
//           canvas: VideoCanvas(uid: uid),
//           connection: RtcConnection(channelId: channelId),
//         ),
//       );
//     }
//
//     // ---- 2 USERS → SPLIT HORIZONTALLY OR VERTICALLY ----
//     if (count == 2) {
//       return Column(
//         children: [
//           Expanded(
//             child: AgoraVideoView(
//               controller: VideoViewController.remote(
//                 rtcEngine: rtcEngine,
//                 canvas: VideoCanvas(uid: remoteUids[0]),
//                 connection: RtcConnection(channelId: channelId),
//               ),
//             ),
//           ),
//           Expanded(
//             child: AgoraVideoView(
//               controller: VideoViewController.remote(
//                 rtcEngine: rtcEngine,
//                 canvas: VideoCanvas(uid: remoteUids[1]),
//                 connection: RtcConnection(channelId: channelId),
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//
//     // ---- 3 OR MORE USERS → GRID ----
//     int crossAxisCount;
//     if (count <= 4) {
//       crossAxisCount = 2;
//     } else if (count <= 9) {
//       crossAxisCount = 3;
//     } else {
//       crossAxisCount = 4;
//     }
//
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         childAspectRatio: 1,
//       ),
//       itemCount: count,
//       itemBuilder: (context, index) {
//         final uid = remoteUids[index];
//
//         return AgoraVideoView(
//           controller: VideoViewController.remote(
//             rtcEngine: rtcEngine,
//             canvas: VideoCanvas(uid: uid),
//             connection: RtcConnection(channelId: channelId),
//           ),
//         );
//       },
//     );
//   }
// }
//
//
// // class RemoteVideoListView extends StatelessWidget {
// //   final RtcEngine rtcEngine;
// //   final String channelId;
// //   final List<int> remoteUids;
// //
// //   const RemoteVideoListView({
// //     super.key,
// //     required this.rtcEngine,
// //     required this.channelId,
// //     required this.remoteUids,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (remoteUids.isEmpty) {
// //       return const Center(child: Text("No remote users yet"));
// //     }
// //
// //     return SizedBox.expand(  // ⬅️ takes all available space
// //       child: GridView.builder(
// //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           childAspectRatio: 1,
// //         ),
// //         itemCount: remoteUids.length,
// //         itemBuilder: (context, index) {
// //           final uid = remoteUids[index];
// //
// //           return AgoraVideoView(
// //             controller: VideoViewController.remote(
// //               rtcEngine: rtcEngine,
// //               canvas: VideoCanvas(uid: uid),
// //               connection: RtcConnection(channelId: channelId),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
//
//
// // class RemoteVideoListView extends StatelessWidget {
// //   final RtcEngine rtcEngine;
// //   final String channelId;
// //   final List<int> remoteUids;
// //
// //   const RemoteVideoListView({
// //     Key? key,
// //     required this.rtcEngine,
// //     required this.channelId,
// //     required this.remoteUids,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (remoteUids.isEmpty) {
// //       return const Center(child: Text("No remote users yet"));
// //     }
// //
// //     return GridView.builder(
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 2, // change for layout
// //         childAspectRatio: 1,
// //       ),
// //       itemCount: remoteUids.length,
// //       itemBuilder: (context, index) {
// //         final uid = remoteUids[index];
// //
// //         return AgoraVideoView(
// //           controller: VideoViewController.remote(
// //             rtcEngine: rtcEngine,
// //             canvas: VideoCanvas(uid: uid),
// //             connection: RtcConnection(channelId: channelId),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
