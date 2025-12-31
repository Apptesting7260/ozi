import 'package:ozi/app/core/appExports/app_export.dart';
import '../../../user/booking/booking details/view/booking_details_screen.dart';
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

            /// TITLE
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
                            :  AppColors.lightGrey2,
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

            /// BOOKINGS LIST
            Expanded(
              child: RefreshIndicator(
                onRefresh: provider.refreshBookings,
                child: provider.filteredBookings.isEmpty
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
                  itemCount: provider.filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = provider.filteredBookings[index];
                    return _BookingCard(
                      booking: booking,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BookingDetailsScreen(
                              bookingData: {
                                'id': booking.id,
                                'name': booking.name,
                                'service': booking.service,
                                'date': booking.date,
                                'time': booking.time,
                                'address': booking.address,
                                'price': booking.price,
                                'status': booking.status,
                                'phone': booking.phone,
                                'email': booking.email,
                                'paymentMethod': booking.paymentMethod,
                                'serviceFee': booking.serviceFee,
                                'imageUrl': booking.imageUrl,
                              },
                              tabIndex: provider.selectedTab,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== WIDGET: BOOKING CARD ====================

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
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
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
                  ),
                ),
                 SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.name,
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        booking.service,
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
                _StatusChip(status: booking.status),
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
                      text: booking.date,
                    ),
                     SizedBox(width: 14),
                    _InfoRowInline(
                      icon: Icons.access_time,
                      text: booking.time,
                    ),
                  ],
                ),
                hBox(5),

                /// LOCATION
                _InfoRowFull(
                  icon: Icons.location_on,
                  text: booking.address,
                ),
              ],
            ),

             SizedBox(height: 10),
             Divider(color: AppColors.darkDividerColor),
             SizedBox(height: 8),

            Text(
              "\$${booking.price.toStringAsFixed(2)}",
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
      case "in_progress":
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



