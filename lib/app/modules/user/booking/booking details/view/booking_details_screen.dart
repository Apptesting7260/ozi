import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final int tabIndex; // 0=All, 1=Ongoing, 2=Upcoming, 3=Completed, 4=Canceled

  const BookingDetailsScreen({
    super.key,
    required this.bookingData,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Booking Details"),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bookingIdAndTotal(),
                    hBox(20),
                    _serviceCards(),
                    hBox(20),

                    if (tabIndex == 1) ...[
                      _otpSection(),
                      hBox(20),
                    ],

                    _serviceProvider(),
                    hBox(20),
                    _bookingDetailsSection(),
                    hBox(20),
                    _paymentMethod(),
                    hBox(20),
                    _paymentSummary(),

                    if (tabIndex == 2)
                      hBox(100)
                    else
                      hBox(20),
                  ],
                ),
              ),
            ),

            // Bottom Button - Only for Upcoming (Cancel Booking in RED)
            if (tabIndex == 2)
              _bottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: _getBottomButton(context),
      ),
    );
  }

  Widget _getBottomButton(BuildContext context) {
    // Upcoming bookings - Cancel Booking button (RED)
    if (tabIndex == 2) {
      return CustomButton(
        text: "Cancel Booking",
        height: 52,
        onPressed: () {
          _showCancelDialog(context);
        },
      );
    }

    // Default (shouldn't reach here)
    return SizedBox.shrink();
  }

  Widget _bookingIdAndTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking ID",
              style: AppFontStyle.text_12_400(AppColors.grey),
            ),
            hBox(4),
            Text(
              "BK-2024-001",
              style: AppFontStyle.text_16_600(AppColors.black),
            ),

            // Show status for canceled bookings
            if (tabIndex == 4) ...[
              hBox(4),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Text(
                    "Cancelled",
                    style: AppFontStyle.text_14_600(AppColors.red),
                  ),
                ),
              ),
            ],

            // Show status for ongoing bookings
            if (tabIndex == 1) ...[
              hBox(4),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Text(
                    "in Progress",
                    style: AppFontStyle.text_14_600(AppColors.orange),
                  ),
                ),
              ),
            ],

            if (tabIndex == 2) ...[
              hBox(4),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Text(
                    "Confirmed",
                    style: AppFontStyle.text_14_600(AppColors.blue),
                  ),
                ),
              ),
            ],

            if (tabIndex == 3) ...[
              hBox(4),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Text(
                    "Completed",
                    style: AppFontStyle.text_14_600(AppColors.primary),
                  ),
                ),
              ),
            ],

          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Total",
              style: AppFontStyle.text_12_400(AppColors.grey),
            ),
            hBox(4),
            Text(
              "\$173.26",
              style: AppFontStyle.text_16_700(AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _serviceCards() {
    return Column(
      children: [
        _serviceCard(
          "Shirt Sleeve Shortening & Fitting...",
          "\$84.13",
        ),
        hBox(12),
        _serviceCard(
          "Shirt Sleeve Shortening & Fitting...",
          "\$84.13",
        ),
      ],
    );
  }

  Widget _serviceCard(String title, String price) {
    return Container(
      padding: EdgeInsets.all(12),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(color: AppColors.containerBorder),
      //   color: AppColors.white,
      // ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImage(
              path: "assets/demo/user1.png",
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          wBox(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.text_14_600(AppColors.black),
                ),
                hBox(4),
                Text(
                  price,
                  style: AppFontStyle.text_14_600(AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Start OTP",
            style: AppFontStyle.text_14_600(AppColors.white),
          ),
          hBox(4),
          Text(
            "Share with provider to begin service",
            style: AppFontStyle.text_12_400(AppColors.white.withOpacity(0.9)),
          ),
          hBox(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _otpBox("1"),
                  wBox(12),
                  _otpBox("1"),
                  wBox(12),
                  _otpBox("1"),
                  wBox(12),
                  _otpBox("1"),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Hide",
                  style: AppFontStyle.text_14_600(AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _otpBox(String digit) {
    return SizedBox(
      width: 45,
      height: 45,
      // decoration: BoxDecoration(
      //   color: AppColors.white.withOpacity(0.2),
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(
      //     color: AppColors.white.withOpacity(0.3),
      //     width: 1,
      //   ),
      // ),
      child: Center(
        child: Text(
          digit,
          style: AppFontStyle.text_20_600(AppColors.white),
        ),
      ),
    );
  }

  Widget _serviceProvider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Service Provider",
          style: AppFontStyle.text_16_600(AppColors.black),
        ),
        hBox(12),
        Container(
          padding: EdgeInsets.all(12),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(12),
          //   border: Border.all(color: AppColors.containerBorder),
          //   color: AppColors.white,
          // ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CustomImage(
                  path: "assets/demo/user2.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              wBox(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Doe",
                      style: AppFontStyle.text_16_600(AppColors.black),
                    ),
                    hBox(2),
                    Text(
                      "Tailor Service",
                      style: AppFontStyle.text_12_400(AppColors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bookingDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Booking Details",
          style: AppFontStyle.text_16_600(AppColors.black),
        ),
        hBox(12),
        _detailRow(
          Icons.calendar_today_outlined,
          "Date",
          "December 10, 2025",
        ),
        hBox(12),
        _detailRow(
          Icons.access_time,
          "Time",
          "9:00 AM",
        ),
        hBox(12),
        _detailRow(
          Icons.location_on_outlined,
          "Address",
          "123 Main Street, Apt 4B, San Francisco, CA 94102",
        ),
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        wBox(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppFontStyle.text_12_400(AppColors.grey),
              ),
              hBox(2),
              Text(
                value,
                style: AppFontStyle.text_14_500(AppColors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Method",
          style: AppFontStyle.text_16_600(AppColors.black),
        ),
        hBox(12),
        Container(
          padding: EdgeInsets.all(14),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(12),
          //   border: Border.all(color: AppColors.containerBorder),
          //   color: AppColors.white,
          // ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                // decoration: BoxDecoration(
                //   color: AppColors.lightGrey,
                //   borderRadius: BorderRadius.circular(8),
                // ),
                child: Icon(
                  Icons.credit_card,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              wBox(12),
              Text(
                "Visa •••• 4242",
                style: AppFontStyle.text_14_600(AppColors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Summary",
          style: AppFontStyle.text_16_600(AppColors.black),
        ),
        hBox(12),
        Container(
          padding: EdgeInsets.all(16),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(12),
          //   border: Border.all(color: AppColors.containerBorder),
          //   color: AppColors.white,
          // ),
          child: Column(
            children: [
              _summaryRow("Subtotal", "\$168.26"),
              hBox(12),
              _summaryRow("Service Fee", "\$5.00"),
              hBox(16),
              Divider(color: AppColors.black.withValues(alpha: 0.10), thickness: 2,),
              hBox(12),
              _summaryRow("Total", "\$173.26", isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppFontStyle.text_16_600(AppColors.black)
              : AppFontStyle.text_14_400(AppColors.grey),
        ),
        Text(
          value,
          style: isTotal
              ? AppFontStyle.text_16_700(AppColors.primary)
              : AppFontStyle.text_14_600(AppColors.black),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
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
                Navigator.pop(context); // Go back to bookings list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Booking canceled successfully"),
                    backgroundColor: AppColors.red,
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