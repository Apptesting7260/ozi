import 'package:ozi/app/core/constants/app_urls.dart';
import 'package:ozi/app/view/message/circular_profile_image.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../data/models/chat_models/message_list_model.dart';
import '../../../../data/models/chat_models/page_status_model.dart';
import '../../../../data/network/web_socket_connection_service.dart';
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
    messageDetailsProvider.socket =   navigatorKey.currentContext!.read<SocketController>();
    messageDetailsProvider.socket.ensureOnline();
    messageDetailsProvider.changePageStatus(
      widget.conversionId,
      messageForSend: widget.messageForSend,
      dataLink: widget.dataLink,
    );
    messageDetailsProvider.receivePersonalMessage();
    messageDetailsProvider.startScrollListener();
  }

  @override
  void dispose() {
    // Stop receiving messages or any active streams first
    messageDetailsProvider.changePageStatus('');

    super.dispose();
  }

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
                // backgroundColor: AppColors.chatScaffold,
                //  appBar: AppBar(
                //    backgroundColor: AppColors.chatAppBarColor,
                //    title: Row(
                //      children: [
                //        ShimmerBox(width: 45, height: 45, radius: 45),
                //        SizedBox(width: 12),
                //        ShimmerBox(width: 140, height: 20),
                //      ],
                //    ),
                //  ),
                body: Column(
                  children: [
                    //  Divider(height: 1),
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
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: AppColors.chatAppBarColor,
                  leadingWidth: 23,
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(left: 10),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black87,
                        size: 20,
                      ),
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
                            value.userData?.conversationImage != null &&
                                value.userData!.conversationImage!.isNotEmpty
                            ? '${AppUrls.imageBaseUrl}${value.userData!.conversationImage}'
                            : null,
                        name: value.userData?.conversationName ?? '',
                      ),

                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          value.userData?.conversationName ?? '',
                          style: AppFontStyle.text_18_600(
                            AppColors.chatAppBarTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // actions: [
                  //   PopupMenuButton<String>(
                  //     icon: Icon(
                  //       Icons.more_vert,s
                  //       color: AppColors.chatAppBarMenuIconColor,
                  //     ),
                  //     onSelected: (value) {
                  //       switch (value) {
                  //         case 'view_profile':
                  //           break;
                  //         case 'clear_chat':
                  //           break;
                  //         case 'block':
                  //           break;
                  //       }
                  //     },
                  //     itemBuilder: (BuildContext context) => [
                  //       const PopupMenuItem(
                  //         value: 'view_profile',
                  //         child: Text('View Profile'),
                  //       ),
                  //       const PopupMenuItem(
                  //         value: 'clear_chat',
                  //         child: Text('Clear Chat'),
                  //       ),
                  //       const PopupMenuItem(
                  //         value: 'block',
                  //         child: Text('Block User'),
                  //       ),
                  //     ],
                  //   ),
                  // ],
                ),
                body: Column(
                  children: [
                    hBox(14),
                    //   Divider(color: AppColors.primary, height: 1),// MessageScreen.adsWidget,
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
                            value.userData?.conversationImage ?? "",
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
    String profileImage,
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

    content = SizedBox();

    switch (msg.dataLink != null
        ? "link"
        : msg.fileUrl!.isEmpty
        ? 'text'
        : getFileType(msg.fileUrl?[0] ?? '')) {
      case 'text':
        content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                maxLines: 8,
                msg.text ?? '',
                style: isSent
                    ? AppFontStyle.text_16_400(AppColors.chatSenderTextColor)
                    : AppFontStyle.text_16_400(AppColors.chatReciverTextColor),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              Get.formatTimeToAmPm(msg.createdAt ?? ''),
              style: isSent
                  ? AppFontStyle.text_12_400(AppColors.chatSenderTextColor)
                  : AppFontStyle.text_12_400(AppColors.chatTimeTextColor),
            ),
          ],
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
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //   Image with placeholder/blur
                //   SizedBox(
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
        break;

      case 'video':
        content = GestureDetector(
          onTap: () {},
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
        content = Text('audio');
        break;
    }

    return GestureDetector(
      onTapDown: (details) {
        // messageDetailsProvider.tapPosition = details.globalPosition;
      },
      onLongPress: () {
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
                    // if (!isSent) ...[
                    //   CustomImage(
                    //     path: '${AppUrls.imageBaseUrl}$profileImage',
                    //     borderRadius: BorderRadius.circular(30),
                    //     height: 30,
                    //     width: 30,
                    //   ),
                    //   SizedBox(width: 8),
                    // ],
                    Flexible(
                      child: Container(
                        margin: margin,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSent
                              ? AppColors
                                    .chatSenderColor // green sender bubble
                              : AppColors
                                    .chatReciverColor, // light grey receiver bubble
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isSent ? 16 : 4),
                            bottomRight: Radius.circular(isSent ? 4 : 16),
                          ),
                        ),
                        child: content,
                      ),
                    ),
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
                const SizedBox(height: 4),
                // Tick stays inside
                if (msg.senderType == 'you')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [if (msg.status == 'waiting') SizedBox.shrink()],
                  ),
              ],
            ),
            const SizedBox(height: 2), // Space between bubble and time
            // Padding(
            //   padding: isSent
            //       ? const EdgeInsets.only(right: 10)
            //       : const EdgeInsets.only(left: 10),
            //   child: Text(
            //     Get.timeAgo(msg.createdAt ?? ''),
            //     style: AppFontStyle.text_12_400(AppColors.chatTimeTextColor)
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  String getFileType(String url) {
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

  void _showMessageOptions({
    required BuildContext context,
    required MessageDetailsProvider provider,

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
            Divider(color: AppColors.dividerColor),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.chatTextFieldColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
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

                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
          ],
        );
      },
    );
  }
}
