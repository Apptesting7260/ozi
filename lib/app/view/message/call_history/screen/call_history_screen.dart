// import '../../../../../../core/appExports/app_export.dart';
//
// class CallHistoryScreen extends StatelessWidget {
//   const CallHistoryScreen({super.key});
//
//   final List<Map<String, String>> dummyCalls = const [
//     {
//       "username": "Alice Smith",
//       "status": "Missed",
//       "type": "Audio",
//       "duration": "1h",
//       "image": "https://randomuser.me/api/portraits/women/1.jpg"
//     },
//     {
//       "username": "Bob Johnson",
//       "status": "Incoming",
//       "type": "Video",
//       "duration": "30m",
//       "image": "https://randomuser.me/api/portraits/men/2.jpg"
//     },
//     {
//       "username": "Cathy Lane",
//       "status": "Outgoing",
//       "type": "Audio",
//       "duration": "15m",
//       "image": "https://randomuser.me/api/portraits/women/3.jpg"
//     },
//     {
//       "username": "David Wilson",
//       "status": "Missed",
//       "type": "Video",
//       "duration": "5m",
//       "image": "https://randomuser.me/api/portraits/men/4.jpg"
//     },
//     {
//       "username": "David Wilson",
//       "status": "Answered",
//       "type": "Video",
//       "duration": "5m",
//       "image": "https://randomuser.me/api/portraits/men/4.jpg"
//     },
//     {
//       "username": "Alice Smith",
//       "status": "Missed",
//       "type": "Audio",
//       "duration": "1h",
//       "image": "https://randomuser.me/api/portraits/women/1.jpg"
//     },
//     {
//       "username": "Bob Johnson",
//       "status": "Incoming",
//       "type": "Video",
//       "duration": "30m",
//       "image": "https://randomuser.me/api/portraits/men/2.jpg"
//     },
//     {
//       "username": "Cathy Lane",
//       "status": "Outgoing",
//       "type": "Audio",
//       "duration": "15m",
//       "image": "https://randomuser.me/api/portraits/women/3.jpg"
//     },
//     {
//       "username": "David Wilson",
//       "status": "Missed",
//       "type": "Video",
//       "duration": "5m",
//       "image": "https://randomuser.me/api/portraits/men/4.jpg"
//     },
//     {
//       "username": "David Wilson",
//       "status": "Answered",
//       "type": "Video",
//       "duration": "5m",
//       "image": "https://randomuser.me/api/portraits/men/4.jpg"
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: context.white,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         title: Text(
//           "Call History",
//           style: AppFontStyle.text_22_500(context.darkBlack),
//         ),
//         centerTitle: true,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 15),
//           child: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: CustomImage(
//               path: ImageConstants.backButtonWithBackground,
//             ),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: CustomImage(path: ImageConstants.filterIcon),
//           ),
//         ],
//         backgroundColor: context.white,
//         elevation: 0,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         itemCount: dummyCalls.length,
//         itemBuilder: (context, index) {
//           final call = dummyCalls[index];
//
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: context.white,
//             ),
//             child: Row(
//               children: [
//                 // User Image
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundImage: NetworkImage(call["image"]!),
//                 ),
//                 const SizedBox(width: 12),
//
//                 // Username + Status
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(call["username"]!,
//                           style: AppFontStyle.text_18_500(context.darkText)),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Text(
//                             call["status"]!,
//                             style: AppFontStyle.text_16_300(
//                               call["status"] == "Missed"
//                                   ? context.redText
//                                   :call["status"]=='Answered'? context.greenColor:context.subTitleColor,
//                             ),
//                           ),
//                           wBox(10),
//                           if(call["status"]=='Answered')
//                           Text(
//                             '• 1:10:00',
//                             style: AppFontStyle.text_16_300(context.subTitleColor,),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Call Type + Duration
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       call["type"]!,
//                       style:AppFontStyle.text_16_300(context.darkBlack),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       call["duration"]!,
//                       style:AppFontStyle.text_16_300(context.subTitleColor),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
