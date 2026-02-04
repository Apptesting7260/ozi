// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import '../../../../../../core/appExports/app_export.dart';
//
// import '../model/group_messages_model.dart';
// import '../provider/group_message_details_provider.dart';
//
// class GroupMessageDetailsScreen extends StatefulWidget {
//   const GroupMessageDetailsScreen({super.key});
//
//   @override
//   State<GroupMessageDetailsScreen> createState() => _GroupMessageDetailsScreenState();
// }
//
// class _GroupMessageDetailsScreenState extends State<GroupMessageDetailsScreen> {
//
//
//   GroupMessageDetailsProvider groupMessageDetailsProvider = GroupMessageDetailsProvider();
//
//   @override
//   void initState() {
//     super.initState();
//
//     groupMessageDetailsProvider.focusNode.addListener(() {
//       if (groupMessageDetailsProvider.focusNode.hasFocus && groupMessageDetailsProvider.showEmojiPicker) {
//         groupMessageDetailsProvider.updateShowEmojiPicker(false);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     groupMessageDetailsProvider.controller.dispose();
//     groupMessageDetailsProvider.focusNode.dispose();
//     super.dispose();
//   }
//
//   void _onEmojiSelected(String emoji) {
//     groupMessageDetailsProvider.controller.text += emoji;
//     groupMessageDetailsProvider.controller.selection = TextSelection.fromPosition(TextPosition(offset: groupMessageDetailsProvider.controller.text.length));
//   }
//
//   void _toggleEmojiPicker() {
//     FocusScope.of(navigatorKey.currentContext!).unfocus();
//     groupMessageDetailsProvider.updateShowEmojiPicker(!groupMessageDetailsProvider.showEmojiPicker);
//   }
//
//   String getYouTubeThumbnail(String url) {
//     final id = url.split('/').last;
//     return 'https://img.youtube.com/vi/$id/0.jpg';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//     final yesterday = now.subtract(Duration(days: 1));
//     final twoDaysAgo = now.subtract(Duration(days: 2));
//
//     final messages = [
//       GroupMessageModel(
//         content: "Hey! How are you?",
//         isSent: false,
//         senderName: "John Doe",
//         senderImage: "https://img.freepik.com/free-photo/portrait-smiling-businessman_23-2149157785.jpg",
//         type: MessageTypeGroup.text,
//         time: "9:00 AM",
//         status: 0,
//         dateTime: twoDaysAgo,
//       ),
//       GroupMessageModel(
//         content: "I'm good, you?",
//         isSent: true,
//         type: MessageTypeGroup.text,
//         time: "9:01 AM",
//         status: 3,
//         dateTime: twoDaysAgo,
//       ),
//       GroupMessageModel(
//         content: "I'm good, you?",
//         isSent: true,
//         type: MessageTypeGroup.text,
//         time: "9:01 AM",
//         status: 2,
//         dateTime: twoDaysAgo,
//       ),
//       GroupMessageModel(
//         content: "I'm good, you?",
//         isSent: true,
//         type: MessageTypeGroup.text,
//         time: "9:01 AM",
//         status: 1,
//         dateTime: twoDaysAgo,
//       ),
//       GroupMessageModel(
//         content: "https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png",
//         isSent: false,
//         senderName: "John Doe",
//         senderImage: "https://img.freepik.com/free-photo/portrait-smiling-businessman_23-2149157785.jpg",
//         type: MessageTypeGroup.image,
//         time: "9:03 AM",
//         status: 0,
//         dateTime: yesterday,
//       ),
//       GroupMessageModel(
//         content: "Nice pic!",
//         isSent: true,
//         type: MessageTypeGroup.text,
//         time: "9:05 AM",
//         status: 2,
//         dateTime: yesterday,
//       ),
//       GroupMessageModel(
//         content: "https://www.youtube.com/shorts/N0pwLtonPdg",
//         isSent: false,
//         senderName: "John Doe",
//         senderImage: "https://img.freepik.com/free-photo/portrait-smiling-businessman_23-2149157785.jpg",
//         type: MessageTypeGroup.video,
//         time: "9:10 AM",
//         status: 0,
//         dateTime: now,
//       ),
//       GroupMessageModel(
//         content: "https://commondatastorage.googleapis.com/codeskulptor-assets/jump.ogg",
//         isSent: true,
//         type: MessageTypeGroup.audio,
//         time: "9:12 AM",
//         status: 3,
//         dateTime: now,
//       ),
//       GroupMessageModel(
//         content: "What about tonight?",
//         isSent: false,
//         senderName: "John Doe",
//         senderImage: "https://img.freepik.com/free-photo/portrait-smiling-businessman_23-2149157785.jpg",
//         type: MessageTypeGroup.text,
//         time: "9:15 AM",
//         status: 0,
//         dateTime: now,
//       ),
//       GroupMessageModel(
//         content: "Let's go!",
//         isSent: true,
//         type: MessageTypeGroup.text,
//         time: "9:16 AM",
//         status: 3,
//         dateTime: now,
//       ),
//     ];
//
//
//     return Scaffold(
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         backgroundColor: context.white,
//         leadingWidth: 23,
//         leading:InkWell(
//             onTap: () => Navigator.pop(context),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 15),
//               child: CustomImage(
//                   path: ImageConstants.arrowBack),
//             )),
//         title: Row(
//           children: [
//             CircularProfileImage(
//               imageUrl:
//               "https://img.freepik.com/free-photo/side-view-woman-posing-studio_23-2149883733.jpg?ga=GA1.1.566530418.1743653700&semt=ais_hybrid&w=740",
//               borderColor:Colors.transparent,size: 54,
//             ),
//             // CircularProfileImage(
//             //     child: CustomImage(
//             //         shimmerChild: Container(color: Colors.grey,),
//             //         width: 54,
//             //         height: 54,
//             //         path: "https://img.freepik.com/free-photo/side-view-woman-posing-studio_23-2149883733.jpg?ga=GA1.1.566530418.1743653700&semt=ais_hybrid&w=740")
//             // ),
//             SizedBox(width: 10),
//             Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Friends Group", style: AppFontStyle.text_18_500(context.titleColor)),
//                 Text("Friends Group", style: AppFontStyle.text_14_300(context.subTitleColor)),
//               ],
//             )),
//           ],
//         ),
//         actions: [
//           InkWell(
//               onTap: (){
//                 Navigator.pushNamed(context, AppRoutes.videoRingingCallCard);
//               },
//               child: CustomImage(path: ImageConstants.videoCallIcon)),
//           wBox(13),
//           InkWell(
//               onTap: (){
//                 Navigator.pushNamed(context, AppRoutes.ringingCallCard);
//               },
//               child: CustomImage(path: ImageConstants.callIcon)),
//           wBox(13),
//           InkWell(
//               onTap: (){
//                 //Navigator.pushNamed(context, AppRoutes.ringingCallCard);
//               },
//               child: CustomImage(path: ImageConstants.moreIcon)),
//           wBox(16)
//         ],
//       ),
//       body: Column(
//         children: [
//           hBox(14),
//           Divider(color: context.interestBorder,height: 1,),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(12),
//               children: buildChatList(messages, context),
//             ),
//           ),
//           _buildInputBar(),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> buildChatList(List<GroupMessageModel> messages, BuildContext context) {
//     messages.sort((a, b) => a.dateTime.compareTo(b.dateTime)); // Ensure sorted
//     List<Widget> widgets = [];
//
//     DateTime? lastDate;
//
//     for (final msg in messages) {
//       final date = DateTime(msg.dateTime.year, msg.dateTime.month, msg.dateTime.day);
//       if (lastDate == null || date != lastDate) {
//         lastDate = date;
//         widgets.add(_buildDateLabel(_formatDateLabel(date)));
//       }
//       widgets.add(_buildMessageBubble(msg, getYouTubeThumbnail, context));
//     }
//
//     return widgets;
//   }
//
//   String _formatDateLabel(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(Duration(days: 1));
//
//     if (date == today) return "Today";
//     if (date == yesterday) return "Yesterday";
//     return "${date.day}/${date.month}/${date.year}";
//   }
//
//   Widget _buildDateLabel(String date) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         child: Text(date, style: AppFontStyle.text_16_300(navigatorKey.currentContext!.subTitleColor)),
//       ),
//     );
//   }
//
//   Widget _buildMessageBubble(GroupMessageModel msg, String Function(String) getYTThumb,BuildContext context) {
//     final align = msg.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start;
//     final margin = msg.isSent
//         ? const EdgeInsets.only(left: 40, bottom: 0)
//         : const EdgeInsets.only(right: 40, bottom: 0);
//     Text(msg.time, style: TextStyle(fontSize: 10, color: Colors.grey));
//
//     Widget content;
//
//     switch (msg.type) {
//       case MessageTypeGroup.text:
//         content = Text(msg.content,style: AppFontStyle.text_16_300(context.titleColor),);
//         break;
//       case MessageTypeGroup.image:
//         content = GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => FullScreenImage(imageUrl: msg.content),
//               ),
//             );
//           },
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(msg.content, width: 200),
//           ),
//         );
//         break;
//
//       case MessageTypeGroup.video:
//         final thumbnail = getYTThumb(msg.content);
//         content = GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => VideoPlayerScreen(videoUrl: msg.content),
//               ),
//             );
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(thumbnail, width: 200),
//               ),
//               Icon(Icons.play_circle_fill, color: context.white, size: 48),
//             ],
//           ),
//         );
//         break;
//
//       case MessageTypeGroup.audio:
//         content = AudioMessageWidget(audioUrl: msg.content);
//         break;
//
//     }
//
//     return GestureDetector(
//       onTapDown: (details) {
//         groupMessageDetailsProvider.tapPosition = details.globalPosition;
//       },
//       onLongPress: () {
//         groupMessageDetailsProvider.updateSelectedMessage(msg);
//         _showReactionOverlay(context);
//       },
//       child: Align(
//         alignment: msg.isSent ? Alignment.centerRight : Alignment.centerLeft,
//         child: Column(
//           crossAxisAlignment: msg.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             // Message bubble
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: msg.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
//               children: [
//                 if(!msg.isSent)
//                   CircularProfileImage(
//                     imageUrl: msg.senderImage ?? '',
//                     borderColor: Colors.transparent,
//                     size: 30,
//                   ),
//                 // CircularProfileImage(
//                 //   child: CustomImage(path: msg.senderImage??'', width: 30, height: 30),
//                 // ),
//
//                 wBox(10),
//                 Container(
//                   margin: margin,
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: msg.isSent ? context.blueShade : context.greyShade,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: align,
//                     children: [
//                       content,
//                       if (msg.reaction != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: Text(msg.reaction!, style: TextStyle(fontSize: 16)),
//                         ),
//                       const SizedBox(height: 4),
//                       // Tick stays inside
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           if(msg.status==1)
//                             CustomImage(path: ImageConstants.sendOneIcon),
//                           if(msg.status==2)
//                             CustomImage(path: ImageConstants.sendDoubleIcon),
//                           if(msg.status==3)
//                             CustomImage(path: ImageConstants.sendDoubleIconDark,),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 2),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 wBox(42),
//                 if(!msg.isSent)
//                 Padding(
//                   padding: const EdgeInsets.only(right: 4),
//                   child: SizedBox(
//                     width: 80,
//                     child: Text(
//                       msg.senderName??'',
//                       style: AppFontStyle.text_14_300(context.primary),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: msg.isSent
//                       ? const EdgeInsets.only(right: 10)
//                       : const EdgeInsets.only(left: 10),
//                   child: Text(
//                     msg.time,
//                     style: AppFontStyle.text_14_300(context.subTitleColor),
//                   ),
//                 ),
//               ],
//             )
//             // Padding(
//             //   padding: msg.isSent
//             //       ? const EdgeInsets.only(right: 10)
//             //       : const EdgeInsets.only(left: 10),
//             //   child: Text(
//             //     msg.time,
//             //     style: AppFontStyle.text_14_300(context.subTitleColor),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//
//   }
//
//   void _showReactionOverlay(BuildContext context) {
//     if (groupMessageDetailsProvider.tapPosition == null || groupMessageDetailsProvider.selectedMessage == null) return;
//
//     final overlay = Overlay.of(context);
//     late OverlayEntry entry;
//
//     entry = OverlayEntry(
//       builder: (_) => GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () {
//           entry.remove();
//         },
//         child: Stack(
//           children: [
//             Positioned(
//               top: groupMessageDetailsProvider.tapPosition!.dy - 50,
//               left: groupMessageDetailsProvider.tapPosition!.dx - 100,
//               child: GestureDetector(
//                 onTap: () {}, // Absorb taps on emoji container to prevent dismiss
//                 child: Material(
//                   color: Colors.transparent,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: context.white,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: ["❤️", "😂", "😮", "😢", "😡", "👍"].map((emoji) {
//                         return GestureDetector(
//                           onTap: () {
//                             groupMessageDetailsProvider.selectedMessage?.reaction = emoji;
//                             groupMessageDetailsProvider.selectedMessage = null;
//                             entry.remove(); // Auto-dismiss after selection
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 6),
//                             child: Text(emoji, style: TextStyle(fontSize: 24)),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     overlay.insert(entry);
//   }
//
//
//
//
//
//   Widget _buildInputBar() {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.only(left: 15,right: 7),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(100),
//             color: navigatorKey.currentContext!.fieldBgColor,
//           ),
//           child: Row(
//             children: [
//               InkWell(
//                 onTap: _toggleEmojiPicker,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 5),
//                   child: CustomImage(path: ImageConstants.emojiIcon),
//                 ),
//               ),
//               // IconButton(
//               //   icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
//               //   onPressed: _toggleEmojiPicker,
//               // ),
//               Expanded(
//                 child: TextField(
//                   controller: groupMessageDetailsProvider.controller,
//                   focusNode: groupMessageDetailsProvider.focusNode,
//                   decoration: InputDecoration(
//                     hintText: "Type a message...",
//                     hintStyle: AppFontStyle.text_18_300(navigatorKey.currentContext!.hintTextColor),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 7,right: 3),
//                     child: CustomImage(path: ImageConstants.docsIcon),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 3,right: 4),
//                     child: CustomImage(path: ImageConstants.micIcon),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 7,bottom: 7,left: 3),
//                     child: Container(
//                         width: 46,
//                         height: 46,
//                         // padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: navigatorKey.currentContext!.primary,
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                         child: Center(
//                           child: SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CustomImage(
//                                 path: ImageConstants.sendIcon
//                             ),
//                           ),
//                         )),
//                   ),
//                 ],
//               )
//
//             ],
//           ),
//         ),
//         if (groupMessageDetailsProvider.showEmojiPicker)
//           SizedBox(
//             height: 250,
//             child: EmojiPicker(
//               onEmojiSelected: (category, emoji) {
//                 _onEmojiSelected(emoji.emoji);
//               },
//               config: Config(
//                 // columns: 7,
//                 // emojiSizeMax: 32,
//                 // verticalSpacing: 0,
//                 // horizontalSpacing: 0,
//                 // initCategory: Category.SMILEYS,
//                 // bgColor: context.white,
//                 // indicatorColor: Colors.blue,
//                 // iconColorSelected: Colors.blue,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
// }
//
//
//
//
// class FullScreenImage extends StatelessWidget {
//   final String imageUrl;
//   const FullScreenImage({super.key, required this.imageUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(backgroundColor: Colors.transparent),
//       body: Center(
//         child: InteractiveViewer(
//           child: Image.network(imageUrl),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerScreen({super.key, required this.videoUrl});
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   bool isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() => isInitialized = true);
//         _controller.play();
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(backgroundColor: Colors.transparent),
//       body: Center(
//         child: isInitialized
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : CircularProgressIndicator(),
//       ),
//       floatingActionButton: isInitialized
//           ? FloatingActionButton(
//         onPressed: () {
//           setState(() => _controller.value.isPlaying
//               ? _controller.pause()
//               : _controller.play());
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       )
//           : null,
//     );
//   }
// }
//
//
//
//
//
// class AudioMessageWidget extends StatefulWidget {
//   final String audioUrl;
//   const AudioMessageWidget({super.key, required this.audioUrl});
//
//   @override
//   State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
// }
//
// class _AudioMessageWidgetState extends State<AudioMessageWidget> {
//   // late AudioPlayer _player;
//   bool isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // _player = AudioPlayer();
//
//     _initAudio();
//
//     // Auto-pause when completed
//     // _player.playerStateStream.listen((state) {
//     //   if (state.processingState == ProcessingState.completed) {
//     //     setState(() {
//     //       isPlaying = false;
//     //     });
//     //     _player.seek(Duration.zero); // Optional: reset to start
//     //   }
//     // });
//   }
//
//   Future<void> _initAudio() async {
//     try {
//       // await _player.setUrl(widget.audioUrl);
//     } catch (e) {
//       debugPrint("Error loading audio: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     // _player.dispose();
//     super.dispose();
//   }
//
//   void togglePlay() async {
//     if (isPlaying) {
//       // await _player.pause();
//     } else {
//       // await _player.play();
//     }
//     setState(() => isPlaying = !isPlaying);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: togglePlay,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.blue),
//           const SizedBox(width: 8),
//           Text("Audio Message", style: TextStyle(color: Colors.black87)),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
