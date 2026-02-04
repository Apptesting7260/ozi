// import 'package:g_clout_media/core/commanAddsSection/commanaddsscreen.dart';
//
// import '../../../../../../core/appExports/app_export.dart';
// import '../../../../../Custom/widgets/custom_circular_image_widget.dart';
//
// class VideoCallRingingCard extends StatefulWidget {
//   const VideoCallRingingCard({super.key});
//
//   @override
//   State<VideoCallRingingCard> createState() => _VideoCallRingingCardState();
// }
//
// class _VideoCallRingingCardState extends State<VideoCallRingingCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: context.primary,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         backgroundColor: context.primary,
//         centerTitle: true,
//         leading: const SizedBox(),
//         title: Text(
//           "Video Call with robertaanny_123",
//           style: AppFontStyle.text_18_400(context.white),
//         ),
//       ),
//       body: Column(
//         children: [
//           MessageScreen.adsWidget,
//           hBox(14),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     _buildAnimatedRings(),
//                     CircularProfileImage(
//                       imageUrl:
//                           "https://img.freepik.com/free-photo/side-view-woman-posing-studio_23-2149883733.jpg",
//                       size: 140,
//                       borderColor: Colors.transparent,
//                     ),
//                     // CircularProfileImage(
//                     //   child: CustomImage(
//                     //     shimmerChild: Container(color: Colors.grey),
//                     //     width: 140,
//                     //     height: 140,
//                     //     path:
//                     //     "https://img.freepik.com/free-photo/side-view-woman-posing-studio_23-2149883733.jpg",
//                     //   ),
//                     // ),
//                   ],
//                 ),
//                 hBox(30),
//                 Text(
//                   "Robertaanny_123",
//                   style: AppFontStyle.text_28_500(context.white),
//                 ),
//                 hBox(20),
//                 Text(
//                   "Ringing...",
//                   style: AppFontStyle.text_22_400(context.white),
//                 ),
//               ],
//             ),
//           ),
//           _buildInputBar(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputBar(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.only(left: 15, right: 7),
//             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _circleButton(context.white, ImageConstants.micIcon),
//                 _circleButton(
//                   context.white,
//                   ImageConstants.speakerIcon,
//                   margin: const EdgeInsets.symmetric(horizontal: 10),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: _circleButton(
//                     context.redBackground,
//                     ImageConstants.flatCallIcon,
//                     iconColor: context.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _circleButton(
//     Color bgColor,
//     String iconPath, {
//     EdgeInsets margin = EdgeInsets.zero,
//     Color? iconColor,
//   }) {
//     return Container(
//       width: 60,
//       height: 60,
//       margin: margin,
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(100),
//       ),
//       child: Center(
//         child: CustomImage(
//           height: 30,
//           width: 30,
//           path: iconPath,
//           color: iconColor,
//         ),
//       ),
//     );
//   }
// }
