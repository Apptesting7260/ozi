import 'package:provider/provider.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../provider/BookingConfirmProvider.dart';

class BookingConfirmScreen extends StatelessWidget {
  const BookingConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingConfirmProvider(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Consumer<BookingConfirmProvider>(
                  builder: (context, provider, _) {
                    return SingleChildScrollView(
                      padding: REdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
          
                          SizedBox(height: 10),
          
                          _successIcon(),
          
                          SizedBox(height: 14),
          
                          Text(
                            "Booking Confirmed!",
                            style: AppFontStyle.text_20_700(
                              AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
          
                          SizedBox(height: 6),
          
                          Text(
                            "Your service has been booked successfully",
                            style: AppFontStyle.text_14_400(
                              AppColors.darkText,
                            ),
                            textAlign: TextAlign.center,
                          ),
          
                          SizedBox(height: 20),
          
                          _bookingID(provider),
          
                          SizedBox(height: 20),
          
                          _otpCard(provider),
          
                          SizedBox(height: 20),
          
                          _detailsCard(provider),
          
                          SizedBox(height: 100),
                        ],
                      ),
                    );
                  },
                ),
              ),
          
              _viewBookingsButton(),
          
              SizedBox(height: 16),
          
              _bottomActions(),
          
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _successIcon() {
    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: AppColors.primary,
          size: 45,
        ),
      ),
    );
  }

  Widget _bookingID(BookingConfirmProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],

      ),

      child: Column(
        children: [
          Text(
            "Booking ID",
            style: AppFontStyle.text_14_500(AppColors.darkText),
          ),
          SizedBox(height: 4),
          Text(
            provider.bookingId,
            style: AppFontStyle.text_16_700(AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget _otpCard(BookingConfirmProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.primary,
      ),
      child: Column(
        children: [
          Text(
            "Service Start OTP",
            style: AppFontStyle.text_16_700(AppColors.white),
          ),
          SizedBox(height: 4),
          Text(
            "Share with provider to begin service",
            style: AppFontStyle.text_12_400(AppColors.white),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: provider.otp
                .map(
                  (e) => Container(
                height: 50,
                width: 45,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: AppColors.transparent.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    e,
                    style: AppFontStyle.text_20_700(AppColors.white),
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _detailsCard(BookingConfirmProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Title
          Text(
            "Booking Details",
            style: AppFontStyle.text_16_600(
              AppColors.black,
              fontFamily: AppFontFamily.bold,
            ),
          ),

          SizedBox(height: 18),

          /// Service
          Text(
            "Service",
            style: AppFontStyle.text_12_500(AppColors.grey),
          ),
          SizedBox(height: 4),
          Text(
            provider.serviceName,
            style: AppFontStyle.text_14_600(AppColors.black),
          ),

          SizedBox(height: 14),

          /// Provider name
          Text(
            "Service Provider",
            style: AppFontStyle.text_12_500(AppColors.grey),
          ),
          SizedBox(height: 4),
          Text(
            provider.providerName,
            style: AppFontStyle.text_14_600(AppColors.black),
          ),

          SizedBox(height: 22),

          /// Date
          _detailsRow(
            icon: Icons.calendar_today_rounded,
            label: "Date",
            value: provider.bookingDate,
          ),
          SizedBox(height: 10),

          /// Time
          _detailsRow(
            icon: Icons.access_time_filled_rounded,
            label: "Time",
            value: provider.bookingTime,
          ),
          SizedBox(height: 10),

          /// Address
          _detailsRow(
            icon: Icons.location_on_rounded,
            label: "Address",
            value: provider.address,
          ),

          SizedBox(height: 22),
          Divider(color: AppColors.containerBorder),

          SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: AppFontStyle.text_16_600(AppColors.black),
              ),
              Text(
                "\$${provider.total.toStringAsFixed(2)}",
                style: AppFontStyle.text_16_700(AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailsRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: AppColors.primary,
              size: 16),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppFontStyle.text_12_500(AppColors.grey),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: AppFontStyle.text_14_600(AppColors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _viewBookingsButton() {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: CustomButton(
        text: "View My Bookings",
        onPressed: () {},
        borderRadius: BorderRadius.circular(60),
      ),
    );
  }

  Widget _bottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // --------- Home Button ----------
        CustomButton(
          isOutlined: true,
          color: AppColors.lightGrey2,
          width: 180,
          borderRadius: BorderRadius.circular(60),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                path: ImageConstants.home1,
                height: 20,
                width: 20,
              ),
             wBox(8),
              Text(
                "Home",
                style: AppFontStyle.text_14_500(
                  AppColors.black,
                  fontFamily: AppFontFamily.medium,
                ),
              ),
            ],
          ),
        ),

        wBox(20),

        // --------- Share Button ----------
        CustomButton(
          isOutlined: true,
          color: AppColors.lightGrey2,
          width: 180,
          borderRadius: BorderRadius.circular(60),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                path: ImageConstants.share,
                height: 20,
                width: 20,
              ),
              wBox(8),
              Text(
                "Share",
                style: AppFontStyle.text_14_500(
                  AppColors.black,
                  fontFamily: AppFontFamily.medium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



}
