import 'package:ozi/app/core/constants/app_urls.dart';
import 'package:ozi/app/view/message/circular_profile_image.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../data/models/chat_models/message_list_model.dart';
import '../../../../data/models/chat_models/page_status_model.dart';
import '../../../../data/response/api_status.dart';
import '../../../../shared/widgets/custom_shimmer_box.dart';
import '../provider/message_details_provider.dart';

class MessageDetailsScreen extends StatefulWidget {
  const MessageDetailsScreen({
    super.key,
    required this.conversionId,
    this.messageForSend,
    this.dataLink,
  });
  final String conversionId;
  final String? messageForSend;
  final String? dataLink;

  @override
  State<MessageDetailsScreen> createState() => _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends State<MessageDetailsScreen> {
  MessageDetailsProvider messageDetailsProvider = MessageDetailsProvider();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('conversion id is ${widget.conversionId}');
    }
    messageDetailsProvider.changePageStatus(
      widget.conversionId,
      messageForSend: widget.messageForSend,
      dataLink: widget.dataLink,
    );
    messageDetailsProvider.receivePersonalMessage();
    messageDetailsProvider.startScrollListener();
    // messageDetailsProvider.focusNode.addListener(() {
    //   if (messageDetailsProvider.focusNode.hasFocus &&
    //       messageDetailsProvider.showEmojiPicker) {
    //     messageDetailsProvider.updateShowEmojiPicker(false);
    //   }
    // });
  }

  @override
  void dispose() {
    // Stop receiving messages or any active streams first
    messageDetailsProvider.changePageStatus('');

    super.dispose();
  }

  // void _toggleEmojiPicker() {
  //   FocusScope.of(navigatorKey.currentContext!).unfocus();
  //   messageDetailsProvider.updateShowEmojiPicker(
  //     !messageDetailsProvider.showEmojiPicker,
  //   );
  // }

  // String getYouTubeThumbnail(String url) {
  //   final id = url.split('/').last;
  //   return 'https://img.youtube.com/vi/$id/0.jpg';
  // }

  // Future<String?> getYouTubeThumbnail(String videoUrl) async {
  //   try {
  //     final uint8list = await VideoThumbnail.thumbnailFile(
  //       video: videoUrl,
  //       thumbnailPath: (await Directory.systemTemp.createTemp()).path,
  //       imageFormat: ImageFormat.JPEG,
  //       maxHeight: 200, // height of thumbnail
  //       quality: 75,
  //     );
  //
  //     return uint8list; // path to thumbnail image
  //   } catch (e) {
  //     print('Error generating thumbnail: $e');
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final _ = now.subtract(Duration(days: 1));
    final _ = now.subtract(Duration(days: 2));

    return ChangeNotifierProvider.value(
      value: messageDetailsProvider,
      child: Consumer<MessageDetailsProvider>(
        builder: (context, value, child) {
          switch (value.messageListData.status) {
            case ApiStatus.loading:
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      ShimmerBox(width: 45, height: 45, radius: 45),
                      SizedBox(width: 12),
                      ShimmerBox(width: 140, height: 20),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(12),
                        itemCount: 12,
                        reverse: true,
                        itemBuilder: (context, index) {
                          bool isSender = index.isEven;

                          return Column(
                            crossAxisAlignment: isSender
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: isSender
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  if (!isSender)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ShimmerBox(
                                        width: 32,
                                        height: 32,
                                        radius: 32,
                                      ),
                                    ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ShimmerBox(
                                          width: Get.width() * 0.5,
                                          height: 14,
                                        ),
                                        SizedBox(height: 6),
                                        ShimmerBox(
                                          width: Get.width() * 0.35,
                                          height: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: isSender
                                    ? const EdgeInsets.only(right: 10)
                                    : const EdgeInsets.only(left: 10),
                                child: ShimmerBox(
                                  width: 60,
                                  height: 12,
                                  radius: 4,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    /// INPUT BAR SHIMMER
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ShimmerBox(
                              width: double.infinity,
                              height: 48,
                              radius: 100,
                            ),
                          ),
                          SizedBox(width: 10),
                          ShimmerBox(width: 48, height: 48, radius: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              );

            // return Scaffold(body: CustomLoader());
            case ApiStatus.completed:
              bool isGroup = (value.userData?.allParticipants?.length ?? 0) > 2;
              return Scaffold(
                floatingActionButton: value.isNewMessageReceived
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: FloatingActionButton(
                          onPressed: value.scrollToBottom,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.arrow_downward,
                            color: AppColors.white,
                          ),
                        ),
                      )
                    : null,
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  backgroundColor: AppColors.white,
                  leadingWidth: 23,
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(left: 10),
                      child: Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                  ),
                  // leading: InkWell(
                  //   onTap: () => Navigator.pop(context),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 15),
                  //     child: SizedBox(
                  //         width: 5,
                  //         height: 5,
                  //         child: CustomImage(path: ImageConstants.backArrow)),
                  //   ),
                  // ),
                  title: Row(
                    children: [
                      CircularProfileImage(
                        size: 45,
                        imageUrl:
                            '${AppUrls.imageBaseUrl}${value.userData?.conversationImage ?? ''}',
                      ),
                      // CustomImage(
                      //   path: value.userData?.conversationImage ?? '',
                      //   // borderColor: Colors.transparent,
                      //   // size: 54,
                      // ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          value.userData?.conversationName ?? '',
                          style: AppFontStyle.text_18_500(AppColors.hintText),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pushNamed(context, AppRoutes.ringingCallCard,arguments: {
                    //       "conversationId": widget.conversionId,
                    //       "callType":'video',
                    //       "userName": value.userData?.conversationName ?? '',
                    //       "userImageUrl": value.userData?.conversationImage ?? '',
                    //     });
                    //     // Navigator.pushNamed(
                    //     //   context,
                    //     //   AppRoutes.videoRingingCallCard,
                    //     // );
                    //   },
                    //   child: CustomImage(path: ImageConstants.videoCallIcon),
                    // ),
                    // wBox(10),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pushNamed(context, AppRoutes.ringingCallCard,arguments: {
                    //       "conversationId": widget.conversionId,
                    //       "callType":'audio',
                    //       "userName": value.userData?.conversationName ?? '',
                    //       "userImageUrl": value.userData?.conversationImage ?? '',
                    //     });
                    //   },
                    //   child: CustomImage(path: ImageConstants.callIcon),
                    // ),
                    wBox(16),
                  ],
                ),
                body: Column(
                  children: [
                    hBox(14),
                    Divider(color: AppColors.primary, height: 1),
                    // MessageScreen.adsWidget,
                    Expanded(
                      child: ListView.builder(
                        controller: value.scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(12),
                        itemCount: value.messageListData.data?.data.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          MessageListModelData? msg =
                              value.messageListData.data!.data[index];
                          return buildMessageItem(
                            msg,
                            context,
                            isGroup,
                            index,
                            value,
                          );
                        },
                        // children: buildChatList(value.messageListData?.data??[] ?? [], context),
                      ),
                    ),

                    // Expanded(
                    //   child: ListView(
                    //     padding: const EdgeInsets.all(12),
                    //     children: buildChatList(value.messageListData?.data??[], context),
                    //   ),
                    // ),
                    _buildInputBar(),
                  ],
                ),
              );
            default:
              return Text('Error Occurred');
          }
        },
      ),
    );
  }

  Widget buildMessageItem(
    MessageListModelData msg,
    BuildContext context,
    bool isGroup,
    int index,
    MessageDetailsProvider messageDetailsProvider,
  ) {
    List<AllParticipants> participants =
        messageDetailsProvider.userData?.allParticipants
            ?.where((element) => element.id == msg.senderId)
            .toList() ??
        <AllParticipants>[];

    bool isSent = msg.senderType == 'you';
    final align = isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final margin = isSent
        ? const EdgeInsets.only(left: 40, bottom: 0)
        : const EdgeInsets.only(right: 40, bottom: 0);
    final _ = isSent
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Get.timeAgo(msg.createdAt ?? ''),
                style: AppFontStyle.text_14_300(AppColors.grey),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.done,
                size: 14,
                color: msg.status == 3 ? Colors.green : Colors.grey,
              ),
              // if (msg.status >= 2)
              //   Icon(Icons.done, size: 14, color: msg.status == 3 ? Colors.green : Colors.grey),
            ],
          )
        : Text(
            Get.timeAgo(msg.createdAt ?? ''),
            style: TextStyle(fontSize: 10, color: Colors.grey),
          );

    Widget content;

    content =
        SizedBox(); //Text(msg.text??'',style: AppFontStyle.text_16_300(context.titleColor),maxLines: 200,);

    switch (msg.dataLink != null
        ? "link"
        : msg.fileUrl!.isEmpty
        ? 'text'
        : getFileType(msg.fileUrl?[0] ?? '')) {
      case 'text':
        content = Text(
          msg.text ?? '',
          style: AppFontStyle.text_16_300(
            AppColors.primary,
            overflow: TextOverflow.clip,
          ),
          maxLines: 200,
        );
        break;
      case 'image':
        content = GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder:
            //         (_) => FullScreenImage(imageUrl: msg.fileUrl?[0] ?? ''),
            //   ),
            // );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with placeholder/blur
                SizedBox(
                  width: Get.width() * 0.4,
                  height: 200,
                  child: msg.mediaUploadLoading == true
                      ? Container(
                          width: Get.width() * 0.4,
                          height: 200,
                          color: Colors.grey[300], // blank space placeholder
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: msg.fileUrl?[0] ?? '',
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => Container(
                            width: Get.width() * 0.4,
                            height: 200,
                            color: Colors.grey[300], // blank space placeholder
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                ),
                if (msg.text != null) SizedBox(height: 5),
                if (msg.text != null)
                  Text(
                    msg.text ?? '',
                    style: AppFontStyle.text_16_300(AppColors.primary),
                    maxLines: 200,
                  ),
              ],
            ),
          ),
        );
      case 'link':
        content = GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder:
            //         (_) => FullScreenImage(imageUrl: msg.fileUrl?[0] ?? ''),
            //   ),
            // );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with placeholder/blur
                // SizedBox(
                //   width: Get.width() * 0.4,
                //   height: 200,
                //   child: UrlPreviewWidget(url: msg.dataLink??'') ),
                if (msg.text != null) SizedBox(height: 5),
                if (msg.text != null)
                  Text(
                    msg.text ?? '',
                    style: AppFontStyle.text_16_300(AppColors.primary),
                    maxLines: 200,
                  ),
              ],
            ),
          ),
        );
        // content = GestureDetector(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (_) => FullScreenImage(imageUrl: msg.fileUrl?[0]??''),
        //       ),
        //     );
        //   },
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(8),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         SizedBox(child: CustomImage(path: msg.fileUrl?[0]??'',fit: BoxFit.fitWidth,width:Get.width()*0.4,height: 200,)),
        //         if(msg.text!=null)
        //           SizedBox(height: 5,),
        //         if(msg.text!=null)
        //         Text(msg.text??'',style: AppFontStyle.text_16_300(context.titleColor),maxLines: 200,)
        //       ],
        //     ),
        //   ),
        // );
        break;

      case 'video':
        // final thumbnail = getYTThumb(msg.fileUrl?[0]??'');
        // final thumbnail = getYTThumb(msg.fileUrl?[0]??'');
        content = GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder:
            //         (_) => VideoPlayerScreen(videoUrl: msg.fileUrl?[0] ?? ''),
            //   ),
            // );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImage(path: '', width: 200, height: 200),
                  ),
                  Icon(
                    Icons.play_circle_fill,
                    color: AppColors.white,
                    size: 48,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                msg.text ?? '',
                style: AppFontStyle.text_16_300(AppColors.primary),
                maxLines: 200,
              ),
            ],
          ),
        );
        break;

      case 'audio':
        content = Text(
          'audio',
        ); //AudioMessageWidget(audioUrl: msg.fileUrl?[0] ?? '');
        break;
    }

    return GestureDetector(
      onTapDown: (details) {
        // messageDetailsProvider.tapPosition = details.globalPosition;
      },
      onLongPress: () {
        // messageDetailsProvider.updateSelectedMessage(msg);
        // _showReactionOverlay(context);
        _showMessageOptions(
          context: context,
          index: index,
          provider: messageDetailsProvider,
          msgId: msg.sId ?? '',
          msgText: msg.text,
          senderType: msg.senderType ?? '',
          // isFile:
        );
      },
      child: Align(
        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isSent
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Message bubble
            Column(
              crossAxisAlignment: align,
              children: [
                Row(
                  mainAxisAlignment: isSent
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isGroup && !isSent) ...[
                      CustomImage(
                        path: participants[0].profile ?? "",
                        borderRadius: BorderRadius.circular(30),
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        margin: margin,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSent
                              ? AppColors.blueShade
                              : AppColors.greyShade,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: content,
                      ),
                    ),
                    // if(isGroup && isSent) ...[
                    //   SBox(width: 8,),
                    //   CustomImage(path: participants[0].profile ?? "",borderRadius: BorderRadius.circular(30),height: 30,width: 30,),
                    // ],
                  ],
                ),
                if (msg.reactions != null && msg.reactions!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      msg.reactions!
                          .map((r) => r.reaction) // extract each reaction
                          .where(
                            (r) => r != null && r.isNotEmpty,
                          ) // filter out null/empty
                          .join(' '), // join all reactions with space
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                // if (msg.reactions != null && msg.reactions!.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 4),
                //     child: Text(
                //       msg.reactions?[0].reaction ?? 'dd',
                //       style: TextStyle(fontSize: 16),
                //     ),
                //   ),
                const SizedBox(height: 4),
                // Tick stays inside
                if (msg.senderType == 'you')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // if (msg.status == 'sent')
                      //   CustomImage(path: ImageConstants.sendOneIcon),
                      // if (msg.status == 'delivered')
                      //   CustomImage(
                      //     path: ImageConstants.sendDoubleIcon,
                      //     color: Colors.grey,
                      //   ),
                      // if (msg.status == 'seen')
                      CustomImage(
                        path: ImageConstants.pause,
                        color: Colors.green,
                      ),
                      if (msg.status == 'waiting') SizedBox.shrink(),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 2), // Space between bubble and time
            Padding(
              padding: isSent
                  ? const EdgeInsets.only(right: 10)
                  : const EdgeInsets.only(left: 10),
              child: Text(
                Get.timeAgo(msg.createdAt ?? ''),
                style: AppFontStyle.text_14_300(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List<Widget> buildChatList(List<MessageListModelData> messages, BuildContext context) {
  //   // messages.sort((a, b) => a.dateTime.compareTo(b.dateTime)); // Ensure sorted
  //   List<Widget> widgets = [];
  //
  //   DateTime? lastDate;
  //
  //   for (final msg in messages) {
  //     // final date = Get.formatDate(msg.createdAt??'');
  //     // if (lastDate == null || date.day != lastDate.day||date.month != lastDate.month || date.year != lastDate.year) {
  //     //   lastDate = date;
  //     //   widgets.add(_buildDateLabel(_formatDateLabel(date)));
  //     // }
  //     widgets.add(_buildMessageBubble(msg, getYouTubeThumbnail, context));
  //   }
  //
  //   return widgets;
  // }

  String getFileType(String url) {
    // Convert to lowercase to make comparison case-insensitive
    final lowerUrl = url.toLowerCase();

    // Check for image extensions
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    for (var ext in imageExtensions) {
      if (lowerUrl.endsWith(ext)) return 'image';
    }

    // Check for video extensions
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.flv'];
    for (var ext in videoExtensions) {
      if (lowerUrl.endsWith(ext)) return 'video';
    }

    // Check for audio extensions
    final audioExtensions = ['.mp3', '.wav', '.aac', '.ogg', '.flac', '.m4a'];
    for (var ext in audioExtensions) {
      if (lowerUrl.endsWith(ext)) return 'audio';
    }

    // Default if unknown
    return 'file';
  }

  // void _showReactionOverlay(BuildContext context) {
  //   if (messageDetailsProvider.tapPosition == null ||
  //       messageDetailsProvider.selectedMessage == null)
  //     return;
  //
  //   final overlay = Overlay.of(context);
  //   late OverlayEntry entry;
  //
  //   entry = OverlayEntry(
  //     builder:
  //         (_) => GestureDetector(
  //           behavior: HitTestBehavior.translucent,
  //           onTap: () {
  //             entry.remove();
  //           },
  //           child: Stack(
  //             children: [
  //               Positioned(
  //                 top: messageDetailsProvider.tapPosition!.dy - 50,
  //                 left: messageDetailsProvider.tapPosition!.dx - 100,
  //                 child: GestureDetector(
  //                   onTap:
  //                       () {}, // Absorb taps on emoji container to prevent dismiss
  //                   child: Material(
  //                     color: Colors.transparent,
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 12,
  //                         vertical: 8,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: context.white,
  //                         borderRadius: BorderRadius.circular(24),
  //                         boxShadow: [
  //                           BoxShadow(color: Colors.black26, blurRadius: 5),
  //                         ],
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children:
  //                             ["❤️", "😂", "😮", "😢", "😡", "👍"].map((emoji) {
  //                               return GestureDetector(
  //                                 onTap: () {
  //                                   print(
  //                                     messageDetailsProvider
  //                                         .selectedMessage
  //                                         ?.text,
  //                                   );
  //                                   messageDetailsProvider.reactionOnMessage(
  //                                     widget.conversionId,
  //                                     emoji,
  //                                   );
  //                                   entry
  //                                       .remove(); // Auto-dismiss after selection
  //                                 },
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                     horizontal: 6,
  //                                   ),
  //                                   child: Text(
  //                                     emoji,
  //                                     style: TextStyle(fontSize: 24),
  //                                   ),
  //                                 ),
  //                               );
  //                             }).toList(),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //   );
  //
  //   overlay.insert(entry);
  // }

  // void _showEmojiBottomSheet({
  //   required BuildContext context,
  //   // required String msgId,
  //   // required SingleChatController controller,
  //   // required bool isSender,
  //   required int index,
  //   // required bool isFile,
  // }) {
  //   showModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (context) {
  //       return SafeArea(
  //         child: SizedBox(
  //           height: 300,
  //           child: EmojiPicker(
  //             onEmojiSelected: (category, emoji) {
  //               print("emoji select from package : $emoji");
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showMessageOptions({
    required BuildContext context,
    required MessageDetailsProvider provider,
    // required String msgId,
    // required SingleChatController controller,
    // required bool isSender,
    required int index,
    required String msgId,
    required String senderType,
    String? msgText,
    // required bool isFile,
  }) {
    // controller.isEditing = false;
    // controller.isReplying = false;
    // controller.update();
    // log("msg id is $msgId ");
    showDialog(
      context: context,
      barrierDismissible: true, // Close on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji Reactions
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var emoji in [
                      "❤️",
                      "  😂",
                      "  😮",
                      "  😢",
                      "  👍",
                      "  👎",
                    ])
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if (kDebugMode) {
                            print("emoji picked from popup : $emoji");
                          }
                          provider.rectionOnMessage(
                            widget.conversionId,
                            emoji,
                            msgId,
                          );
                          // controller.reactionMsgChat(emoji, msgId, index);
                        },
                        child: Text(emoji, style: TextStyle(fontSize: 24)),
                      ),
                    SizedBox(width: 10),
                    // GestureDetector(
                    //                     //   onTap: () {
                    //                     //     Navigator.pop(context);
                    //                     //
                    //                     //     // _showEmojiBottomSheet(context: context, index: index);
                    //                     //   },
                    //                     //   child: Icon(
                    //                     //     Icons.add_circle_outline,
                    //                     //     size: 28,
                    //                     //     color: Colors.white,
                    //                     //   ),
                    //                     // ),
                  ],
                ),
              ),

              Divider(color: Colors.grey),
              if (msgText != null)
                _buildOption(context, "Copy", Icons.copy, () {
                  Navigator.pop(context);
                  // final String messageText =
                  // controller.msgListObj.data![index].message?.text message ??
                  // '';
                  Clipboard.setData(ClipboardData(text: msgText)).then((_) {
                    //
                    Get.showToast(
                      "Copied to clipboard",
                      type: ToastType.success,
                    );
                  });
                }),

              // Message Options
              // if (controller.msgListObj.data![index].message?.file == null ||
              //     controller.msgListObj.data![index].message!.file!.isEmpty)
              //   _buildOption(context, "Reply", Icons.reply, () {
              //     Navigator.pop(context);
              //     controller.isReplying = true;
              //     controller.replyingID = msgId;

              //     controller.update();
              //     // Handle Reply
              //   }),
              // _buildOption(context, "Edit", Icons.edit, () {}),

              // Delete Option
              if (senderType == 'you')
                _buildOption(context, "Delete", Icons.delete, () async {
                  Navigator.pop(context);
                  provider.deleteAMessage(msgId, widget.conversionId);
                }, color: Colors.red),
            ],
          ),
        );
      },
    );
  }

  // Helper Function for Options
  Widget _buildOption(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            SizedBox(width: 10),
            Text(text, style: TextStyle(color: color, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Consumer<MessageDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.fieldBgColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextFormField(
                controller: provider.controller,
                focusNode: provider.focusNode,
                style: AppFontStyle.text_18_400(AppColors.primary),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: AppFontStyle.text_18_300(AppColors.hintText),
                  border: InputBorder.none,
                  isDense: true,

                  contentPadding: const EdgeInsets.symmetric(vertical: 10),

                  /// Leading widget (emoji button)
                  // prefixIcon: IconButton(
                  //   onPressed: _toggleEmojiPicker,
                  //   icon: CustomImage(path: ImageConstants.emojiIcon),
                  //   constraints: const BoxConstraints(),
                  //   padding: EdgeInsets.zero,
                  // ),

                  /// Trailing widgets (docs, mic, send)
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   onPressed: () => provider.pickFile(),
                      //   icon: CustomImage(path: ImageConstants.docsIcon),
                      //   constraints: const BoxConstraints(),
                      //   padding: EdgeInsets.zero,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 4),
                      //   child: CustomImage(path: ImageConstants.micIcon),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 4),
                      //   child: AudioRecorderButton(
                      //     onAudioSend: (audioFile) {
                      //       print("Audio file recorded: ${audioFile.path}");
                      //       // 👉 Send this file to your function
                      //       // uploadAudio(audioFile);
                      //       Navigator.push(
                      //         navigatorKey.currentContext!,
                      //         MaterialPageRoute(
                      //           builder:
                      //               (context) => FilePreviewScreen(
                      //             file: audioFile,
                      //             fileType: "audio",
                      //             onSend: (File file, String fileType) {
                      //               provider.sendImagesOrVideosOrFiles(
                      //                 [file],
                      //                 fileType == 'image'
                      //                     ? UploadFileType.image
                      //                     : fileType == 'video'
                      //                     ? UploadFileType.video
                      //                     : UploadFileType.audio,
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () =>
                            provider.sendPersonalMessage(widget.conversionId),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CustomImage(path: ImageConstants.sendIcon),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Emoji Picker
            // if (provider.showEmojiPicker)
            //   SizedBox(
            //     height: 250,
            //     child: EmojiPicker(
            //       onEmojiSelected: (category, emoji) {
            //         _onEmojiSelected(emoji.emoji);
            //       },
            //       config: const Config(),
            //     ),
            //   ),
          ],
        );
      },
    );
  }

  // Widget _buildInputBar() {
  //   return Consumer<MessageDetailsProvider>(builder: (context, value, child) {
  //       return Column(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.only(left: 15,right: 7),
  //             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(100),
  //               color: navigatorKey.currentContext!.fieldBgColor,
  //             ),
  //             child: Row(
  //               children: [
  //                 InkWell(
  //                   onTap: _toggleEmojiPicker,
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(right: 5),
  //                     child: CustomImage(path: ImageConstants.emojiIcon),
  //                   ),
  //                 ),
  //                 // IconButton(
  //                 //   icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
  //                 //   onPressed: _toggleEmojiPicker,
  //                 // ),
  //                 Expanded(
  //                   child: TextField(
  //                     controller: messageDetailsProvider.controller,
  //                     focusNode: messageDetailsProvider.focusNode,
  //                     decoration: InputDecoration(
  //                       hintText: "Type a message...",
  //                       hintStyle: AppFontStyle.text_18_300(navigatorKey.currentContext!.hintTextColor),
  //                       border: InputBorder.none,
  //                     ),
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     InkWell(
  //                       onTap: (){
  //                          messageDetailsProvider.pickFile(widget.receiverId);
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(left: 7,right: 3),
  //                         child: CustomImage(path: ImageConstants.docsIcon),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 3,right: 4),
  //                       child: CustomImage(path: ImageConstants.micIcon),
  //                     ),
  //                     InkWell(
  //                       onTap: (){
  //                         messageDetailsProvider.sendPersonalMessage(widget.receiverId,widget.conversionId);
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(top: 7,bottom: 7,left: 3),
  //                         child: Container(
  //                             width: 46,
  //                             height: 46,
  //                             // padding: EdgeInsets.all(10),
  //                             decoration: BoxDecoration(
  //                               color: navigatorKey.currentContext!.primary,
  //                               borderRadius: BorderRadius.circular(100),
  //                             ),
  //                             child: Center(
  //                               child: SizedBox(
  //                                 width: 16,
  //                                 height: 16,
  //                                 child: CustomImage(
  //                                     path: ImageConstants.sendIcon
  //                                 ),
  //                               ),
  //                             )),
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //
  //               ],
  //             ),
  //           ),
  //           if (messageDetailsProvider.showEmojiPicker)
  //             SizedBox(
  //               height: 250,
  //               child: EmojiPicker(
  //                 onEmojiSelected: (category, emoji) {
  //                   _onEmojiSelected(emoji.emoji);
  //                 },
  //                 config: Config(
  //                   // columns: 7,
  //                   // emojiSizeMax: 32,
  //                   // verticalSpacing: 0,
  //                   // horizontalSpacing: 0,
  //                   // initCategory: Category.SMILEYS,
  //                   // bgColor: context.white,
  //                   // indicatorColor: Colors.blue,
  //                   // iconColorSelected: Colors.blue,
  //                 ),
  //               ),
  //             ),
  //         ],
  //       );
  //     },);
  // }
}

// class FullScreenImage extends StatelessWidget {
//   final String imageUrl;
//   const FullScreenImage({super.key, required this.imageUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(backgroundColor: Colors.transparent),
//       body: Center(child: InteractiveViewer(child: Image.network(imageUrl))),
//     );
//   }
// }
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
//         child:
//             isInitialized
//                 ? AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//                 : CircularProgressIndicator(),
//       ),
//       floatingActionButton:
//           isInitialized
//               ? FloatingActionButton(
//                 onPressed: () {
//                   setState(
//                     () =>
//                         _controller.value.isPlaying
//                             ? _controller.pause()
//                             : _controller.play(),
//                   );
//                 },
//                 child: Icon(
//                   _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                 ),
//               )
//               : null,
//     );
//   }
// }
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
//   late AudioPlayer _player;
//   bool isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _player = AudioPlayer();
//
//     _initAudio();
//
//     // Auto-pause when completed
//     _player.onPlayerComplete.listen((_) {
//       setState(() => isPlaying = false);
//     });
//
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
//       print("Error loading audio: $e");
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
//        await _player.pause();
//     } else {
//       await _player.play(UrlSource(widget.audioUrl));
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
