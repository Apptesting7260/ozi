import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/core/constants/app_urls.dart';
import '../../../../data/models/all_bookings_model.dart';
import '../../../../data/models/vendor_home_model.dart';
import '../../../../data/response/api_status.dart';
import '../../../user/booking/booking details/view/booking_details_screen.dart';
import '../booking details/view/vendor_booking_details_screen.dart';
import '../provider/vendor_mybookings_provider.dart';

class VendorMybookingsScreen extends StatelessWidget {
   const VendorMybookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorMybookingsProvider(),
      child:  _MyBookingsContent(),
    );
  }
}

class _MyBookingsContent extends StatelessWidget {
   const _MyBookingsContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VendorMybookingsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             hBox(16),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "My Bookings",
                style: AppFontStyle.text_24_600(AppColors.darkText, fontFamily: AppFontFamily.semiBold)
              ),
            ),

            hBox(16),

            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:  EdgeInsets.symmetric(horizontal: 16),
                itemCount: provider.tabs.length,
                itemBuilder: (_, index) {
                  final selected = provider.selectedTab == index;
                  return GestureDetector(
                    onTap: () => provider.changeTab(index),
                    child: Container(
                      margin:  EdgeInsets.only(right: 10),
                      padding:  EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ?  AppColors.primary
                            :  AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          provider.tabs[index],
                          style: AppFontStyle.text_12_500(
                            selected ? AppColors.white : AppColors.grey,
                            fontFamily: AppFontFamily.medium
                          )
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            hBox(16),

            switch (provider.homeModel.status) {
              ApiStatus.loading =>
              Expanded(child: const Center(child: CircularProgressIndicator())),

              ApiStatus.completed =>
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: provider.getAllBookings,
                      child:provider.homeModel.data?.data==null ||provider.homeModel.data!.data!.isEmpty
                          ? Center(
                        child: Text(
                          "No ${provider.tabs[provider.selectedTab].toLowerCase()} bookings",
                          style:  TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                      )
                          : ListView.builder(
                        padding:  EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.homeModel.data!.data!.length,
                        itemBuilder: (context, index) {
                          final booking = provider.homeModel.data!.data![index];
                          return _BookingCard(
                            booking: booking,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => VendorBookingDetailsScreen( bookingId: booking.id.toString(),),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

              ApiStatus.error =>
              Expanded(child: const Center(child: Text('Something went wrong'))),

              _ =>
              const SizedBox.shrink(),
            },
          ],
        ),
      ),
    );
  }
}

// ==================== WIDGET: BOOKING CARD ====================

class _BookingCard extends StatelessWidget {
  final AllBookingsModelData booking;
  final VoidCallback onTap;

   const _BookingCard({
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:  EdgeInsets.only(bottom: 14),
        padding:  EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset:  Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:  AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child:  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('${AppUrls.imageBaseUrl}${booking.user?.proImg??''}'),
                  ),
                ),
                 SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.user?.firstName??'',
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        booking.bookingCode??'',
                        style:  TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: booking.status??''),
              ],
            ),

            hBox(12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// DATE + TIME
                Row(
                  children: [
                    _InfoRowInline(
                      icon: Icons.calendar_today,
                      text: Get.getFormattedDate(booking.serviceDate??''),
                    ),
                     SizedBox(width: 14),
                    _InfoRowInline(
                      icon: Icons.access_time,
                      text: '${booking.serviceTime?.from??''} - ${booking.serviceTime?.to??''}',
                    ),
                  ],
                ),
                hBox(5),

                /// LOCATION
                _InfoRowFull(
                  icon: Icons.location_on,
                  text: booking.address?.fullAddress??"",
                ),
              ],
            ),

             SizedBox(height: 10),
             Divider(color: AppColors.darkDividerColor),
             SizedBox(height: 8),

            Text(
              "\$${booking.total??''}",
              style:  AppFontStyle.text_16_500(AppColors.primary, fontFamily: AppFontFamily.medium),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRowInline extends StatelessWidget {
  final IconData icon;
  final String text;

   const _InfoRowInline({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
         SizedBox(width: 6),
        Text(
          text,
          style:  TextStyle(fontSize: 12, color: AppColors.grey),
        ),
      ],
    );
  }
}

class _InfoRowFull extends StatelessWidget {
  final IconData icon;
  final String text;

   const _InfoRowFull({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
         SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style:  TextStyle(fontSize: 12, color: AppColors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

   const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String text;
    Color textColor;

    switch (status) {
      case "pending":
        bg = AppColors.orange.withValues(alpha: 0.15);
        text = "Pending";
        textColor = AppColors.orange;
        break;
      case "ongoing":
        bg = AppColors.orange.withValues(alpha: 0.15);
        text = "In Progress";
        textColor = AppColors.orange;
        break;
      case "confirmed":
        bg = AppColors.blue.withValues(alpha: 0.15);
        text = "Confirmed";
        textColor = AppColors.blue;
        break;
      case "completed":
        bg = AppColors.green.withValues(alpha: 0.15);
        text = "Completed";
        textColor = AppColors.green;
        break;
      case "cancelled":
        bg = AppColors.red.withValues(alpha: 0.15);
        text = "Cancelled";
        textColor = AppColors.red;
        break;
      case "rejected":
        bg = AppColors.red.withValues(alpha: 0.15);
        text = "Rejected";
        textColor = AppColors.red;
        break;
      default:
        bg =  AppColors.white;
        text = status;
        textColor =  AppColors.black;
    }

    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppFontStyle.text_11_500(textColor, fontFamily: AppFontFamily.medium)
      ),
    );
  }
}



