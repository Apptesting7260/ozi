import '../../../../core/appExports/app_export.dart';
import '../booking details/view/booking_details_screen.dart';
import '../provider/booking_provider.dart';
import '../model/bookingmodel.dart';
import '../model/bookingmodel.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingProvider(),
      builder: (context, child) {
        // Trigger initial data fetch
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<BookingProvider>().getAllBookings("");
        });

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
                  child: Text(
                    "My Bookings",
                    style: AppFontStyle.text_24_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  ),
                ),
                hBox(10),
                _bookingTabs(),
                hBox(15),
                Expanded(
                  child: Consumer<BookingProvider>(
                    builder: (context, provider, _) {
                      // Show loading indicator
                      if (provider.isLoading && provider.allBookings.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      // Show empty state
                      if (provider.allBookings.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 80,
                                color: AppColors.grey.withValues(alpha: 0.3),
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

                      // Show bookings list with pull to refresh
                      return RefreshIndicator(
                        onRefresh: () async {
                          await provider.refreshBookings(
                            _getStatusForTab(provider.tabIndex),
                          );
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount:
                              provider.allBookings.length +
                              (provider.hasMoreData ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Show loading indicator at bottom for pagination
                            if (index == provider.allBookings.length) {
                              // Trigger pagination fetch
                              provider.loadMoreBookings(
                                _getStatusForTab(provider.tabIndex),
                              );
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            }

                            final booking = provider.allBookings[index];
                            final bookingData = _transformBookingData(
                              booking,
                              provider,
                            );
                            return _bookingCard(
                              context,
                              bookingData,
                              provider.tabIndex,
                              provider,
                              index,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Get status string for API based on tab index
  String _getStatusForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return '';
      case 1:
        return 'Ongoing';
      case 2:
        return 'Upcoming';
      case 3:
        return 'Completed';
      case 4:
        return 'Cancelled';
      default:
        return '';
    }
  }

  String _resolveStatus(Data booking) {
    String status =
        booking.status ?? booking.firstService?.service?.status ?? "";
    return status.trim();
  }

  // Transform Data model to Map format for the card UI
  Map<String, dynamic> _transformBookingData(
    Data booking,
    BookingProvider provider,
  ) {
    String title = booking.firstService?.serviceName ?? 'Service';
    String price = "\$${booking.total ?? '0.00'}";

    String date = "";
    if (booking.serviceDate != null) {
      try {
        DateTime dateTime = DateTime.parse(booking.serviceDate!);
        date =
            "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}";
      } catch (e) {
        date = booking.serviceDate ?? "";
      }
    }
    String time = "";
    if (booking.serviceTime != null) {
      time =
          "${booking.serviceTime?.from ?? ""}-${booking.serviceTime?.to ?? ""}";
    }

    String address = "";
    if (booking.address != null) {
      List<String> parts = [];
      if (booking.address?.streetAddress?.isNotEmpty == true)
        parts.add(booking.address!.streetAddress!);
      if (booking.address?.city?.isNotEmpty == true)
        parts.add(booking.address!.city!);
      address = parts.join(", ");
    }

    // Try booking status first, then fallback to service status if needed
    String status = _resolveStatus(booking);

    String statusColor = _getStatusColor(status);

    return {
      'title': title,
      'price': price,
      'date': date,
      'time': time,
      'address': address,
      'status': status.toUpperCase(),
      'statusColor': statusColor,
      'img': provider.extractServiceImage(booking),
    };
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _getStatusColor(String status) {
    String lower = status.toLowerCase();
    if (lower.contains('complet')) return 'green';
    if (lower.contains('ongoing') || lower.contains('progress')) return 'blue';
    if (lower.contains('confirm') || lower.contains('upcoming'))
      return 'orange';
    if (lower.contains('cancel')) return 'red';
    return 'grey';
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
      onTap: () {
        provider.changeTab(index);
        provider.refreshBookings(_getStatusForTab(index));
      },
      child: Container(
        margin: EdgeInsets.only(left: 12),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.3,
          ),
        ),
        child: Text(
          title,
          style: AppFontStyle.text_14_500(
            selected ? AppColors.white : AppColors.darkText,
          ),
        ),
      ),
    );
  }

  Widget _bookingCard(
    BuildContext context,
    Map<String, dynamic> data,
    int tabIndex,
    BookingProvider provider,
    int index,
  ) {
    Color statusBgColor;
    Color statusTextColor;

    switch (data["statusColor"]) {
      case "green":
        statusBgColor = AppColors
            .lightOrange; // Using orange theme for "completed" as per previous design
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
        statusBgColor = AppColors.lightRed;
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
            color: AppColors.black.withValues(alpha: 0.03),
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
                  path: provider.getFullImageUrl(data["img"]),
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

          _buildActionButtons(
            context,
            provider.allBookings[index],
            tabIndex,
            provider,
            index,
          ),
        ],
      ),
    );
  }

  int _getEffectiveTabIndex(int currentTabIndex, String? status) {
    if (status == null) return currentTabIndex;
    if (currentTabIndex == 0) {
      String lower = status.toLowerCase();
      if (lower.contains('progress') || lower.contains('ongoing')) return 1;
      if (lower.contains('confirm') || lower.contains('upcoming')) return 2;
      if (lower.contains('complet')) return 3;
      if (lower.contains('cancel')) return 4;

      return 0;
    }
    return currentTabIndex;
  }

  Widget _buildActionButtons(
    BuildContext context,
    Data booking,
    int tabIndex,
    BookingProvider provider,
    int index,
  ) {
    // if (booking.vendor?.isdeleted == true) {
    //   return Container(
    //     width: double.infinity,
    //     height: 46,
    //     decoration: BoxDecoration(
    //       color: AppColors.lightGrey2,
    //       borderRadius: BorderRadius.circular(30),
    //     ),
    //     alignment: Alignment.center,
    //     child: Text(
    //       "Vendor is no longer available",
    //       style: AppFontStyle.text_14_500(AppColors.red),
    //     ),
    //   );
    // }

    String status = _resolveStatus(booking);
    int effectiveTabIndex = _getEffectiveTabIndex(tabIndex, status);

    // Common navigation helper
    void navigateToDetails() async {
      await provider.getBookingDetails(booking.bookingId ?? 0);

      if (provider.bookingDetails?.data != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: provider,
              child: BookingDetailsScreen(
                bookingData: provider.bookingDetails!.data!.toJson(),
                tabIndex: effectiveTabIndex,
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to load booking details"),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }

    bool isPending = status.toLowerCase().contains('pending');

    if (effectiveTabIndex == 2 || effectiveTabIndex == 3 || isPending) {
      if (booking.vendor?.isdeleted == true) {
        return Container(
          width: double.infinity,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.lightGrey2,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            "Vendor is no longer available",
            style: AppFontStyle.text_14_500(AppColors.red),
          ),
        );
      }

      if (booking.firstService?.service?.serviceDeleted == true) {
        return Container(
          width: double.infinity,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.lightGrey2,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            "Service is no longer available",
            style: AppFontStyle.text_14_500(AppColors.red),
          ),
        );
      }

      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "View Details",
              isOutlined: true,
              color: AppColors.lightGrey2,
              textStyle: AppFontStyle.text_14_500(
                AppColors.black,
                fontFamily: AppFontFamily.medium,
              ),
              onPressed: navigateToDetails,
            ),
          ),
          wBox(14),
          if (effectiveTabIndex == 2 || isPending)
            if (provider.isCancelling &&
                provider.cancellingBookingId == booking.bookingId)
              SizedBox.shrink()
            else
              Expanded(
                child: CustomButton(
                  text: "Cancel Booking",
                  isOutlined: true,
                  borderColor: AppColors.red,
                  color: AppColors.red,
                  textStyle: AppFontStyle.text_14_500(
                    AppColors.red,
                    fontFamily: AppFontFamily.medium,
                  ),
                  height: 46,
                  onPressed: () => _showCancelDialog(context, booking),
                ),
              )
          else if (effectiveTabIndex == 3)
            Expanded(
              child: CustomButton(
                text: "Book Again",
                isOutlined: false,
                color: AppColors.primary,
                textStyle: AppFontStyle.text_14_500(
                  AppColors.white,
                  fontFamily: AppFontFamily.medium,
                ),
                isLoading:
                    provider.isBookAgainLoading &&
                    provider.bookAgainBookingId == booking.bookingId,
                onPressed: () => provider.bookAgain(booking.bookingId ?? 0),
              ),
            ),
        ],
      );
    }

    if (effectiveTabIndex == 1 || effectiveTabIndex == 0) {
      return CustomButton(
        isOutlined: true,
        text: "View Details",
        textStyle: AppFontStyle.text_14_500(
          AppColors.black,
          fontFamily: AppFontFamily.medium,
        ),
        color: AppColors.lightGrey2,
        height: 46,
        onPressed: navigateToDetails,
      );
    }

    return CustomButton(
      text: "View Details",
      isOutlined: true,
      color: AppColors.lightGrey2,
      textStyle: AppFontStyle.text_14_500(
        AppColors.black,
        fontFamily: AppFontFamily.medium,
      ),
      height: 46,
      onPressed: navigateToDetails,
    );
  }

  void _showCancelDialog(BuildContext context, Data booking) {
    final bookingProvider = context.read<BookingProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ChangeNotifierProvider.value(
          value: bookingProvider,
          child: Consumer<BookingProvider>(
            builder: (context, provider, child) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  "Cancel Booking",
                  style: AppFontStyle.text_18_600(AppColors.black),
                ),
                content: provider.isCancelling
                    ? SizedBox(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : Text(
                        "Are you sure you want to cancel this booking?",
                        style: AppFontStyle.text_14_400(AppColors.darkText),
                      ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(
                      "No",
                      style: AppFontStyle.text_14_500(AppColors.grey),
                    ),
                  ),
                  if (!provider.isCancelling)
                    TextButton(
                      onPressed: () async {
                        await provider.cancelBooking(
                          booking.bookingId ?? 0,
                          context,
                        );
                        // No need for Navigator.pop here, Provider handles it
                      },
                      child: Text(
                        "Yes, Cancel",
                        style: AppFontStyle.text_14_500(AppColors.red),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
