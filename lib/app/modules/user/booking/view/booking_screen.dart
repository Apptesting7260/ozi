import '../../../../core/appExports/app_export.dart';
import '../booking details/view/booking_details_screen.dart';
import '../provider/booking_provider.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingProvider(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(top: 10, left: 20, bottom: 10),
                child: Text(
                  "My Bookings",
                  style: AppFontStyle.text_24_600(AppColors.black, fontFamily: AppFontFamily.semiBold),
                ),
              ),
              hBox(10),
              _bookingTabs(),
              hBox(15),
              Expanded(
                child: Consumer<BookingProvider>(
                  builder: (context, provider, _) {
                    if (provider.bookings.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 80,
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                            hBox(16),
                            Text(
                              "No bookings found",
                              style: AppFontStyle.text_16_600(AppColors.grey),
                            ),
                            hBox(8),
                            Text(
                              "Your bookings will appear here",
                              style: AppFontStyle.text_14_400(AppColors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      physics: BouncingScrollPhysics(),
                      itemCount: provider.bookings.length,
                      itemBuilder: (context, index) {
                        final data = provider.bookings[index];
                        return _bookingCard(context, data, provider.tabIndex, provider);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookingTabs() {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 4),
          physics: BouncingScrollPhysics(),
          child: Row(
            children: [
              _tab("All", 0, provider),
              _tab("Ongoing", 1, provider),
              _tab("Upcoming", 2, provider),
              _tab("Completed", 3, provider),
              _tab("Cancelled", 4, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _tab(String title, int index, BookingProvider provider) {
    bool selected = provider.tabIndex == index;
    return GestureDetector(
      onTap: () => provider.changeTab(index),
      child: Container(
        margin: EdgeInsets.only(left: 12),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.3,
          ),
        ),
        child: Text(
          title,
          style: AppFontStyle.text_14_500(
            selected
                ? AppColors.white
                : AppColors.darkText,
          ),
        ),
      ),
    );
  }

  Widget _bookingCard(BuildContext context, Map<String, dynamic> data, int tabIndex, BookingProvider provider) {
    Color statusBgColor;
    Color statusTextColor;

    switch (data["statusColor"]) {
      case "green":
        statusBgColor = AppColors.lightOrange;
        statusTextColor = AppColors.orange;
        break;
      case "blue":
        statusBgColor = AppColors.lightBlue;
        statusTextColor = AppColors.blue;
        break;
      case "orange":
        statusBgColor = AppColors.primaryLight;
        statusTextColor = AppColors.primary;
        break;
      case "red":
        statusBgColor = Colors.red.withOpacity(0.15);
        statusTextColor = AppColors.red;
        break;
      default:
        statusBgColor = AppColors.lightGrey;
        statusTextColor = AppColors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.containerBorder),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImage(
                  path: data["img"],
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              wBox(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["title"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.text_14_600(AppColors.black),
                    ),
                    hBox(4),
                    Text(
                      data["price"],
                      style: AppFontStyle.text_14_600(AppColors.green),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data["status"],
                  style: AppFontStyle.text_12_600(statusTextColor),
                ),
              ),
            ],
          ),
          hBox(14),
          Row(
            children: [
              Icon(Icons.calendar_month, size: 16, color: AppColors.grey),
              wBox(8),
              Text(
                data["date"],
                style: AppFontStyle.text_12_500(AppColors.grey),
              ),
              wBox(20),
              Icon(Icons.access_time, size: 16, color: AppColors.grey),
              wBox(8),
              Text(
                data["time"],
                style: AppFontStyle.text_12_500(AppColors.grey),
              ),
            ],
          ),
          hBox(8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey),
              wBox(8),
              Expanded(
                child: Text(
                  data["address"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.text_12_500(AppColors.grey),
                ),
              ),
            ],
          ),
          hBox(14),

          // Buttons based on booking status
          _buildActionButtons(context, data, tabIndex, provider),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> data, int tabIndex, BookingProvider provider) {
    // Ongoing bookings - Only View Details button
    if (tabIndex == 1) {
      return CustomButton(
        isOutlined: true,
        text: "View Details",
        textStyle: AppFontStyle.text_14_500(AppColors.black, fontFamily: AppFontFamily.medium),
        color: AppColors.lightGrey2,
        height: 46,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailsScreen(
                bookingData: data,
                tabIndex: provider.tabIndex,
              ),
            ),
          );
        },
      );
    }

    // Upcoming bookings - View Details + Cancel Booking (RED)
    if (tabIndex == 2) {
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "View Details",
              isOutlined: true,
              color: AppColors.lightGrey2 ,
              textStyle: AppFontStyle.text_14_500(AppColors.black, fontFamily: AppFontFamily.medium),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsScreen(
                      bookingData: data,
                      tabIndex: provider.tabIndex,
                    ),
                  ),
                );
              },
            ),
          ),
          wBox(14),
          Expanded(
            child: CustomButton(
              text: "Cancel Booking",
              isOutlined: true,
              color: AppColors.red ,
              textStyle: AppFontStyle.text_14_500(AppColors.red, fontFamily: AppFontFamily.medium),
              height: 46,
              onPressed: () {
                _showCancelDialog(context, data);
              },
            ),
          ),
        ],
      );
    }

    // Completed bookings - View Details + Book Again
    if (tabIndex == 3) {
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "View Details",
              isOutlined: true,
              color: AppColors.lightGrey2 ,
              textStyle: AppFontStyle.text_14_500(AppColors.black, fontFamily: AppFontFamily.medium),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsScreen(
                      bookingData: data,
                      tabIndex: provider.tabIndex,
                    ),
                  ),
                );
              },
            ),
          ),
          wBox(14),
          Expanded(
            child: CustomButton(
              text: "Book Again",
              color: AppColors.primary,
              onPressed: () {
                // Handle book again
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Redirecting to booking..."),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // Canceled bookings - View Details + Book Again
    if (tabIndex == 4) {
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "View Details",
              isOutlined: true,
              color: AppColors.lightGrey2 ,
              textStyle: AppFontStyle.text_14_500(AppColors.black, fontFamily: AppFontFamily.medium),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsScreen(
                      bookingData: data,
                      tabIndex: provider.tabIndex,
                    ),
                  ),
                );
              },
            ),
          ),
          wBox(14),
          Expanded(
            child: CustomButton(
              text: "Book Again",
              color: AppColors.primary,
              onPressed: () {
                // Handle book again
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Redirecting to booking..."),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // Default - View Details button
    return CustomButton(
      text: "View Details",
      height: 46,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsScreen(
              bookingData: data,
              tabIndex: provider.tabIndex,
            ),
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Cancel Booking",
            style: AppFontStyle.text_18_600(AppColors.black),
          ),
          content: Text(
            "Are you sure you want to cancel this booking?",
            style: AppFontStyle.text_14_400(AppColors.darkText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "No",
                style: AppFontStyle.text_14_500(AppColors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Handle cancel booking
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Booking canceled successfully"),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
              child: Text(
                "Yes, Cancel",
                style: AppFontStyle.text_14_500(AppColors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}