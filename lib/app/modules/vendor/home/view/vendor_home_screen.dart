import 'package:ozi/app/core/constants/app_urls.dart';
import 'package:ozi/app/modules/vendor/home/provider/vendor_home_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../data/models/vendor_home_model.dart';
import '../../../../data/response/api_status.dart';
import '../../../../shared/widgets/custom_toggle_switch.dart';
import '../new requests/view/new_request_screen.dart';
import '../notification/view/vendor_notifications_screen.dart';

class VendorHomeScreen extends StatelessWidget {
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>VendorHomeProvider(),
      child: Consumer<VendorHomeProvider>(builder: (context, value, child) {
        return  Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: switch (value.homeModel.status) {
              ApiStatus.loading =>
              const Center(child: CircularProgressIndicator()),

              ApiStatus.completed =>
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(child:
                        SizedBox(height: 10, ),
                        ),

                        /// ---------------- HEADER ----------------
                        _header(context),

                        hBox(20),

                        /// ---------------- ONLINE STATUS ----------------
                        _onlineStatus(),

                        hBox(20),

                        /// ---------------- STATS ----------------
                        _statsGrid(),

                        hBox(24),

                        /// ---------------- NEW REQUESTS ----------------
                        _sectionHeader(
                          context: context,
                          title: "New Requests",
                        ),

                        hBox(12),

                        ListView.builder(
                          itemCount: value.homeModel.data?.requests?.length??0,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            VendorHomeRequests request = value.homeModel.data!.requests![index];
                          return _requestCard(
                              statusColor: AppColors.purple,
                              request:request
                            );
                        },),

                        // _newRequestCard(),
                        //
                        // hBox(16),
                        //
                        // _confirmedRequestCard(),

                        hBox(20),
                      ],
                    ),
                  ),

              ApiStatus.error =>
              const Center(child: Text('Something went wrong')),

              _ =>
              const SizedBox.shrink(),
            },
          ),
        );
      },),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: const NetworkImage(
            "https://i.pravatar.cc/150?img=3",
          ),
        ),

        wBox(12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning",
                style: AppFontStyle.text_12_400(AppColors.grey),
              ),
              Text(
                "John Doe",
                style: AppFontStyle.text_16_600(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ],
          ),
        ),


        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationsScreen(),
              ),
            );
          },
          child: Container(
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
        ),
      ],
    );
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
                      (provider.homeModel.data?.vendorStatus?.isOnline??false) ? "You're Online" : "You're Offline",
                      style: AppFontStyle.text_14_600(
                        AppColors.darkText,
                        fontFamily: AppFontFamily.semiBold,
                      ),
                    ),
                    hBox(4),
                    Text(
                      (provider.homeModel.data?.vendorStatus?.isOnline??false)
                          ? "Ready to receive bookings"
                          : "You are not receiving bookings",
                      style: AppFontStyle.text_12_400(AppColors.grey),
                    ),
                  ],
                ),
              ),

              /// ✅ SWITCH (NOW WORKS)
              CustomToggleSwitch(
                value:  (provider.homeModel.data?.vendorStatus?.isOnline??false),
                onChanged: (bool value){
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
      builder: (context,provider,_) {
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.4,  // Changed from 1.3 to 1.4
          ),
          children: [
            _statTile(
              icon: Icons.attach_money,
              title: "\$${provider.homeModel.data?.dashboard?.todayEarnings??'0'}",
              subtitle: "Today's Earning",
            ),
            _statTile(
              icon: Icons.calendar_today,
              title: provider.homeModel.data?.dashboard?.activeBookings??'0',
              subtitle: "Active Bookings",
            ),
            _statTile(
              icon: Icons.account_balance_wallet,
              title: "\$${provider.homeModel.data?.dashboard?.wallet??'0'}",
              subtitle: "Wallet",
            ),
            _statTile(
              icon: Icons.work_outline,
              title: provider.homeModel.data?.dashboard?.totalJobs??'0',
              subtitle: "Total Jobs",
            ),
          ],
        );
      }
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
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,  // Added this
        children: [
          Container(
            padding: const EdgeInsets.all(8),  // Reduced from 10
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),  // Reduced from 20
          ),
          hBox(8),  // Reduced from 12
          Text(
            title,
            style: AppFontStyle.text_18_600(
              AppColors.darkText,
              fontFamily: AppFontFamily.bold,
            ),
            maxLines: 1,  // Added this
            overflow: TextOverflow.ellipsis,  // Added this
          ),
          hBox(2),  // Reduced from 4
          Text(
            subtitle,
            style: AppFontStyle.text_12_400(AppColors.grey),
            maxLines: 1,  // Added this
            overflow: TextOverflow.ellipsis,  // Added this
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required BuildContext context,
    required String title,
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

        TextButton(
          onPressed: () {
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
        ),
      ],
    );
  }

  // Widget _newRequestCard(VendorHomeRequests request) {
  //   return _requestCard(
  //     status: "New Request",
  //     statusColor: AppColors.purple,
  //     showActions: true,
  //   );
  // }
  //
  // Widget _confirmedRequestCard(VendorHomeRequests request) {
  //   return _requestCard(
  //     status: "Confirmed",
  //     statusColor: AppColors.blue,
  //     showActions: false,
  //   );
  // }

  Widget _requestCard({
    required Color statusColor,
     required VendorHomeRequests request,
  }) {
    return Consumer<VendorHomeProvider>(
      builder: (context,provider,_) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
          Container(
            height: 36,
            width: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: CustomImage(
              path: "${AppUrls.imageBaseUrl}${request.customerImage??''}",
              height: 36,
              width: 36,
            ),
          ),
        ),

        wBox(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.customerName??'',
                          style: AppFontStyle.text_14_600(AppColors.darkText),
                        ),
                        Text(
                          request.bookingCode??'',
                          style: AppFontStyle.text_12_400(AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.status?.toUpperCase()??'',
                      style: AppFontStyle.text_12_500(statusColor),
                    ),
                  ),
                ],
              ),

              hBox(12),

              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                  wBox(6),
                  Text(Get.getFormattedDate(request.serviceDate??''), style: AppFontStyle.text_12_400(AppColors.grey)),
                  wBox(12),
                  Icon(Icons.access_time, size: 14, color: AppColors.grey),
                  wBox(6),
                  Text('${request.serviceTime?.from?.toString()} - ${request.serviceTime?.to?.toString()}', style: AppFontStyle.text_12_400(AppColors.grey)),
                ],
              ),

              hBox(8),

              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.grey),
                  wBox(6),
                  Expanded(
                    child: Text(
                      request.address??'',
                      style: AppFontStyle.text_12_400(AppColors.grey),
                      maxLines: 10,
                    ),
                  ),
                ],
              ),

              hBox(14),
              Divider(thickness: 1, color: AppColors.black.withValues(alpha: 0.10), ),
              hBox(14),

              Row(
                children: [
                  Text(
                    "\$${request.totalAmount??''}",
                    style: AppFontStyle.text_14_600(AppColors.primary),
                  ),
                  const Spacer(),

                  if (request.status=='pending') ...[
                    CustomButton(
                      isLoading: provider.acceptRejectLoading&&provider.currentBookingId==request.bookingId&&provider.currentAction=='reject',
                      height: 40,
                      width: 90,
                      // isOutlined: true,
                      text: "Reject",
                      textStyle: AppFontStyle.text_14_500(AppColors.white),
                      color: AppColors.red,
                      onPressed: () {
                        provider.acceptOrRejectRequest('reject',request.bookingId??'');
                      },
                    ),
                    wBox(10),
                    CustomButton(
                      isLoading: provider.acceptRejectLoading&&provider.currentBookingId==request.bookingId&&provider.currentAction=='accept',
                      height: 40,
                      width: 90,
                      text: "Accept",
                      onPressed: () {
                        provider.acceptOrRejectRequest('accept',request.bookingId??'');
                      },
                    ),
                  ] else
                    GestureDetector(
                      onTap: () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: request.customerPhone,
                        );
                        await launchUrl(launchUri);
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child:
                        Icon(Icons.call, color: Colors.white, size: 18),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
