import 'package:ozi/app/modules/vendor/home/provider/vendor_home_provider.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_toggle_switch.dart';
import '../new requests/view/new_request_screen.dart';
import '../notification/view/vendor_notifications_screen.dart';

class VendorHomeScreen extends StatelessWidget {
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>VendorHomeProvider(),

      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
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

                _newRequestCard(),

                hBox(16),

                _confirmedRequestCard(),

                hBox(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

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


  // =============================================================
  // ONLINE STATUS
  // =============================================================

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
                      provider.isOnline ? "You're Online" : "You're Offline",
                      style: AppFontStyle.text_14_600(
                        AppColors.darkText,
                        fontFamily: AppFontFamily.semiBold,
                      ),
                    ),
                    hBox(4),
                    Text(
                      provider.isOnline
                          ? "Ready to receive bookings"
                          : "You are not receiving bookings",
                      style: AppFontStyle.text_12_400(AppColors.grey),
                    ),
                  ],
                ),
              ),

              /// ✅ SWITCH (NOW WORKS)
              CustomToggleSwitch(
                value: provider.isOnline,
                onChanged: provider.toggleOnline,
              ),
            ],
          ),
        );
      },
    );
  }


  // =============================================================
  // STATS GRID
  // =============================================================

  Widget _statsGrid() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.3,
      ),
      children: [
        _statTile(
          icon: Icons.attach_money,
          title: "\$248.50",
          subtitle: "Today's Earning",
        ),
        _statTile(
          icon: Icons.calendar_today,
          title: "8",
          subtitle: "Active Bookings",
        ),
        _statTile(
          icon: Icons.account_balance_wallet,
          title: "\$3,420",
          subtitle: "Wallet",
        ),
        _statTile(
          icon: Icons.work_outline,
          title: "124",
          subtitle: "Total Jobs",
        ),
      ],
    );
  }

  Widget _statTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          hBox(12),
          Text(
            title,
            style: AppFontStyle.text_18_600(
              AppColors.darkText,
              fontFamily: AppFontFamily.bold,
            ),
          ),
          hBox(4),
          Text(
            subtitle,
            style: AppFontStyle.text_12_400(AppColors.grey),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SECTION HEADER
  // =============================================================

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


  // =============================================================
  // NEW REQUEST CARD
  // =============================================================

  Widget _newRequestCard() {
    return _requestCard(
      status: "New Request",
      statusColor: AppColors.purple,
      showActions: true,
    );
  }

  Widget _confirmedRequestCard() {
    return _requestCard(
      status: "Confirmed",
      statusColor: AppColors.blue,
      showActions: false,
    );
  }

  Widget _requestCard({
    required String status,
    required Color statusColor,
    required bool showActions,
  }) {
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
          path: "https://i.pravatar.cc/150?img=5",
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
                      "Alex Johnson",
                      style: AppFontStyle.text_14_600(AppColors.darkText),
                    ),
                    Text(
                      "Deep Cleaning",
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
                  status,
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
              Text("Today", style: AppFontStyle.text_12_400(AppColors.grey)),
              wBox(12),
              Icon(Icons.access_time, size: 14, color: AppColors.grey),
              wBox(6),
              Text("2:00 PM", style: AppFontStyle.text_12_400(AppColors.grey)),
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
                  "123 Main St, San Francisco",
                  style: AppFontStyle.text_12_400(AppColors.grey),
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
                "\$84.13",
                style: AppFontStyle.text_14_600(AppColors.primary),
              ),
              const Spacer(),

              if (showActions) ...[
                CustomButton(
                  height: 40,
                  width: 90,
                  isOutlined: true,
                  text: "Reject",
                  textStyle: AppFontStyle.text_14_500(AppColors.red),
                  color: AppColors.red,
                  onPressed: () {},
                ),
                wBox(10),
                CustomButton(
                  height: 40,
                  width: 90,
                  text: "Accept",
                  onPressed: () {},
                ),
              ] else
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child:
                  Icon(Icons.call, color: Colors.white, size: 18),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
