import '../../../core/appExports/app_export.dart';
import '../../../core/constants/app_urls.dart';
import '../../../data/models/chat_models/conversion_list_model.dart';
import '../../../data/response/api_status.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/cutom_nodata_widget.dart';
import '../circular_profile_image.dart';
import '../provider/message_provider.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({super.key, this.sharedContent});

  // static const adsWidget = AddsCommanScreen();
  final String? sharedContent;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String? sharedContent;

  @override
  void initState() {
    super.initState();

    sharedContent = widget.sharedContent;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<MessageProvider>().getAllConversions(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('rebuild happends message');
    }
    return Consumer<MessageProvider>(
      builder: (context, value, child) {
        switch (value.allConversionData.status) {
          case ApiStatus.loading:
            return Scaffold(
              appBar: _messageAppBar(context),
              body: Center(child: CircularProgressIndicator()),
            );
          case ApiStatus.completed:
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: _messageAppBar(context),
              body:
                  value.allConversionData.data == null ||
                      value.allConversionData.data?.data?.length == 0
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await value.getAllConversions(true);
                      },
                      child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: Get.height() * 0.7,
                            child: NoDataFoundWidget(
                              message: "No conversations found",
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await value.getAllConversions(true);
                      },
                      child: Column(
                        children: [
                          hBox(14),
                          Divider(color: AppColors.primary, height: 1),
                          // MessageScreen.adsWidget,
                          Expanded(
                            child: ListView.builder(
                              controller: value.scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount:
                                  value.allConversionData.data?.data?.length ??
                                  0,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemBuilder: (context, index) {
                                ConversionListModelData? message =
                                    value.allConversionData.data?.data?[index];
                                final isGroup = message?.chatType != 'personal';
                                final displayName = isGroup
                                    ? message?.groupName ?? ''
                                    : message?.receiver?.userName ?? '';

                                return InkWell(
                                  onTap: () async {
                                    if (kDebugMode) {
                                      print(
                                        'shared content is ${widget.sharedContent}',
                                      );
                                    }
                                    value.readAllCounts(message?.sId ?? '');
                                    await Navigator.pushNamed(
                                      navigatorKey.currentContext!,
                                      AppRoutes.messageDetailsScreen,
                                      arguments: {
                                        "conversion_id": message?.sId ?? '',
                                        "receiver_id":
                                            message?.receiver?.id ?? '',
                                        "isGroup": isGroup,
                                        "dataLink": sharedContent,
                                      },
                                    );

                                    context
                                        .read<MessageProvider>()
                                        .getAllConversions(true);
                                    sharedContent = null;
                                  },
                                  child: Padding(
                                    padding: REdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            CircularProfileImage(
                                              imageUrl: isGroup
                                                  ? message?.groupImage !=
                                                                null &&
                                                            message!
                                                                .groupImage!
                                                                .isNotEmpty
                                                        ? '${AppUrls.imageBaseUrl}${message.groupImage}'
                                                        : null
                                                  : message
                                                                ?.receiver
                                                                ?.profile !=
                                                            null &&
                                                        message!
                                                            .receiver!
                                                            .profile!
                                                            .isNotEmpty
                                                  ? '${AppUrls.imageBaseUrl}${message.receiver!.profile}'
                                                  : null,
                                              name: isGroup
                                                  ? message?.groupName
                                                  : message?.receiver?.userName,
                                              borderColor: Colors.transparent,
                                              size: 60,
                                            ),
                                            if ((message
                                                        ?.participants
                                                        ?.length ??
                                                    0) >
                                                2)
                                              Positioned(
                                                bottom: 1,
                                                right: 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.black,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          5.0,
                                                        ),
                                                    child: Text(
                                                      message
                                                              ?.participants
                                                              ?.length
                                                              .toString() ??
                                                          '',
                                                      style:
                                                          AppFontStyle.text_13_400(
                                                            AppColors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        wBox(12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                displayName,
                                                style: AppFontStyle.text_16_500(
                                                  AppColors.darkText,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                message?.lastMessage?.text ??
                                                    '',
                                                style: AppFontStyle.text_16_300(
                                                  (message?.unreadMsgCount !=
                                                              null &&
                                                          message?.unreadMsgCount !=
                                                              '0')
                                                      ? AppColors.primary
                                                      : AppColors.primary,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          children: [
                                            if (message?.unreadMsgCount !=
                                                    null &&
                                                message?.unreadMsgCount != '0')
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.primary,
                                                ),
                                                child: SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: Center(
                                                    child: Text(
                                                      message?.unreadMsgCount ??
                                                          '',
                                                      style:
                                                          AppFontStyle.text_12_300(
                                                            AppColors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            Text(
                                              Get.timeAgo(
                                                message?.activity ?? '',
                                              ),
                                              style: AppFontStyle.text_14_300(
                                                AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          case ApiStatus.error:
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: _messageAppBar(context),
              body: RefreshIndicator(
                onRefresh: () async {
                  await value.getAllConversions(true);
                },
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: Get.height() * 0.7,
                      child: NoDataFoundWidget(
                        message:
                            value.allConversionData.message ??
                            "Connection failed. Please pull to refresh.",
                      ),
                    ),
                  ],
                ),
              ),
            );
          default:
            return Scaffold(
              appBar: _messageAppBar(context),
              body: Center(
                child: GestureDetector(
                  onTap: () {
                    value.getAllConversions(true);
                  },
                  child: Text("Error Occurred!! Retry"),
                ),
              ),
            );
        }
      },
    );
  }

  AppBar _messageAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leadingWidth: 40,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 20),
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.white,
      elevation: 0,
      title: Text("Messages", style: AppFontStyle.text_20_600(AppColors.black)),
      actions: [
        // InkWell(
        //   onTap: () {
        //     Navigator.pushNamed(context, AppRoutes.callHistoryScreen);
        //   },
        //   child: Padding(
        //     padding: REdgeInsets.only(right: 15),
        //     child: CustomImage(path: ImageConstants.notificationIcon),
        //   ),
        // )
      ],
    );
  }
}
