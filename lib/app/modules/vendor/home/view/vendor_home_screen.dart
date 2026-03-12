import 'package:ozi/app/core/constants/app_urls.dart';
import 'package:ozi/app/modules/vendor/home/provider/vendor_home_provider.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../data/models/vendor_home_model.dart';
import '../../../../data/response/api_response.dart';
import '../../../../data/response/api_status.dart';
import '../../../../shared/widgets/custom_toggle_switch.dart';
import '../../../../view/message/screens/message.dart';
import '../../../user/profile/view/profile_provider/profile_provider.dart';
import '../new requests/view/new_request_screen.dart';
import '../notification/provider/vendor_ notification_provider.dart';
import '../notification/view/vendor_notifications_screen.dart';
import '../request_card/view/request_card_view.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}


class _VendorHomeScreenState extends State<VendorHomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final homeProvider = context.read<VendorHomeProvider>();
      final notificationProvider = context.read<VendorNotificationProvider>();

      homeProvider.setHomeModel(ApiResponse.loading());

      await notificationProvider.getNotifications();

      await homeProvider.getHomeData();
      homeProvider.checkForUpdateLocationAndIsServiceAvailable();

      context.read<ProfileProvider>().fetchUserProfile();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<VendorHomeProvider>(
      builder: (context, value, child) {
        return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await value.getHomeData();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _header(context),

                      hBox(20),

                      _onlineStatus(),

                      hBox(20),

                      /// ONE loader for grid + requests
                      if (value.homeModel.status == ApiStatus.loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 80),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else ...[
                        /// ---------------- STATS ----------------
                        _statsGrid(),

                        hBox(24),

                        /// ---------------- NEW REQUESTS ----------------
                        _sectionHeader(
                          context: context,
                          title: "New Requests",
                          newRequestLength: value.homeModel.data?.requests?.length,
                        ),

                        hBox(12),

                        _requestsList(value),
                      ],

                      hBox(20),
                    ],
                  ),
                ),
              ),
            )
        );
      },
    );
  }

  //  return AlertDialog(
  //
  //           title: const Text("Reject Request"),
  //           content: const Text(
  //             "Are you sure you want to reject this request?\nThis action cannot be undone.",
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context); // close dialog
  //               },
  //               child: const Text("Cancel"),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context); // close dialog
  //                 onConfirm(); // call reject API
  //               },
  //               child: const Text(
  //                 "Reject",
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //             ),
  //           ],
  //         );

  Widget _requestsList(VendorHomeProvider value) {

    if (value.homeModel.data?.requests == null ||
        value.homeModel.data!.requests!.isEmpty) {

      return SizedBox(
        height: 150,
        child: Center(
          child: Text(
            "No new requests available",
            style: AppFontStyle.text_16_500(AppColors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: value.homeModel.data!.requests!.length > 2
          ? 2
          : value.homeModel.data!.requests!.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {

        final request = value.homeModel.data!.requests![index];

        return RequestCard(
          request: request,
          onAccept: () {
            value.acceptOrRejectRequest('accept', request.bookingId ?? '');
          },
          onReject: () {
            _showRejectWarning(context, () {
              value.acceptOrRejectRequest('reject', request.bookingId ?? '');
            });
          },
        );
      },
    );
  }

  void _showRejectWarning(
      BuildContext context,
      VoidCallback onConfirm,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return  Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Consumer<VendorHomeProvider>(
              builder: (context, provider, _) {
                if (provider.popupLoading) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Reject Request",
                      textAlign: TextAlign.center,
                      style: AppFontStyle.text_22_600(
                        Color.fromRGBO(28, 29, 33, 1),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      maxLines: 5,
                      "Are you sure you want to reject this request?\nThis action cannot be undone.",
                      textAlign: TextAlign.center,
                      style: AppFontStyle.text_16_300(
                        Color.fromRGBO(112, 108, 108, 1),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: AppFontStyle.text_16_600(
                                  const Color.fromRGBO(112, 108, 108, 1),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              onConfirm();
                            },
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "Reject",
                                style: AppFontStyle.text_16_600(
                                  const Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }


  Widget _header(BuildContext context) {
    return Consumer<VendorHomeProvider>(
      builder: (context, provider, _) {
        return Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (provider.homeModel.data?.profile?.image != null &&
                  provider.homeModel.data!.profile!.image!.isNotEmpty)
                  ? NetworkImage(
                '${AppUrls.imageBaseUrl}${provider.homeModel.data!.profile!.image}',
              )
                  : null,
              child: (provider.homeModel.data?.profile?.image == null ||
                  provider.homeModel.data!.profile!.image!.isEmpty)
                  ? Text(
                (provider.homeModel.data?.profile?.name?.isNotEmpty ?? false)
                    ? provider.homeModel.data!.profile!.name![0].toUpperCase()
                    : "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
                  : null,
            )
            ,

            wBox(12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getGreetingMessage(),
                    style: AppFontStyle.text_12_400(AppColors.grey),
                  ),

                  provider.homeModel.status == ApiStatus.loading
                      ? Text(
                    "Loading...",
                    style: AppFontStyle.text_16_600(
                      AppColors.grey,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  )
                      : Text(
                    provider.homeModel.data?.profile?.name ?? '',
                    style: AppFontStyle.text_16_600(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen(),));
              },
              child: Image.asset(
                "assets/images/msgimg.png",
                height: 40,
                width: 40,
              ),
            ),
            wBox(10),
            // InkWell(
            //   borderRadius: BorderRadius.circular(40),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => const NotificationsScreen(),
            //       ),
            //     );
            //   },
            //   child: Container(
            //     height: 40,
            //     width: 40,
            //     decoration: BoxDecoration(
            //       color: AppColors.lightGrey,
            //       shape: BoxShape.circle,
            //     ),
            //     child: Center(
            //       child: CustomImage(
            //         path: ImageConstants.bell,
            //         height: 20,
            //         width: 20,
            //         color: AppColors.black,
            //       ),
            //     ),
            //   ),
            // ),
            Consumer<VendorNotificationProvider>(
              builder: (context, provider, _) {
                return InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomImage(
                            path: ImageConstants.bell,
                            height: 20,
                            width: 20,
                            color: AppColors.black,
                          ),
                        ),
                      ),

                      /// Badge
                      if (provider.unreadCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              provider.unreadCount > 99
                                  ? "99+"
                                  : provider.unreadCount.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  Widget _onlineStatus() {
    return Consumer<VendorHomeProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightPrimary2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightPrimary),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (provider.homeModel.data?.vendorStatus?.isOnline ?? false)
                          ? "You're Online"
                          : "You're Offline",
                      style: AppFontStyle.text_14_600(
                        AppColors.darkText,
                        fontFamily: AppFontFamily.semiBold,
                      ),
                    ),
                    hBox(4),
                    Text(
                      (provider.homeModel.data?.vendorStatus?.isOnline ?? false)
                          ? "Ready to receive bookings"
                          : "You are not receiving bookings",
                      style: AppFontStyle.text_12_400(AppColors.grey),
                    ),
                  ],
                ),
              ),

              // SWITCH (NOW WORKS)
              CustomToggleSwitch(
                value:
                (provider.homeModel.data?.vendorStatus?.isOnline ?? false),
                onChanged: (bool value) {
                  provider.toggleOnline();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statsGrid() {
    return Consumer<VendorHomeProvider>(
      builder: (context, provider, _) {
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.4, // Changed from 1.3 to 1.4
          ),
          children: [
            _statTile(
              icon: Icons.attach_money,
              title:
              "\$${provider.homeModel.data?.dashboard?.todayEarnings ?? '0'}",
              subtitle: "Today's Earning",
            ),
            _statTile(
              icon: Icons.calendar_today,
              title: provider.homeModel.data?.dashboard?.activeBookings ?? '0',
              subtitle: "Active Bookings",
            ),
            _statTile(
              icon: Icons.account_balance_wallet,
              title: "\$${provider.homeModel.data?.dashboard?.wallet ?? '0'}",
              subtitle: "Wallet",
            ),
            _statTile(
              icon: Icons.work_outline,
              title: provider.homeModel.data?.dashboard?.totalJobs ?? '0',
              subtitle: "Total Jobs",
            ),
          ],
        );
      },
    );
  }

  Widget _statTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Added this
        children: [
          Container(
            padding: const EdgeInsets.all(8), // Reduced from 10
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 18,
            ), // Reduced from 20
          ),
          hBox(8), // Reduced from 12
          Text(
            title,
            style: AppFontStyle.text_18_600(
              AppColors.darkText,
              fontFamily: AppFontFamily.bold,
            ),
            maxLines: 1, // Added this
            overflow: TextOverflow.ellipsis, // Added this
          ),
          hBox(2), // Reduced from 4
          Text(
            subtitle,
            style: AppFontStyle.text_12_400(AppColors.grey),
            maxLines: 1, // Added this
            overflow: TextOverflow.ellipsis, // Added this
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required BuildContext context,
    required String title,
    required int? newRequestLength
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppFontStyle.text_16_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.semiBold,
          ),
        ),

        newRequestLength != null && newRequestLength >= 2
            ? GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NewRequestsScreen(),
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "View All",
                style: AppFontStyle.text_14_500(AppColors.primary),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.primary,
              ),
            ],
          ),
        )
            : const SizedBox.shrink(),
      ],
    );
  }
}