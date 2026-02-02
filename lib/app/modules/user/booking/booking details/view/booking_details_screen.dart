import 'package:intl/intl.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../provider/booking_provider.dart';
import '../../model/bookingdetailsmodel.dart' as model;

class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final int tabIndex;

  const BookingDetailsScreen({
    super.key,
    required this.bookingData,
    required this.tabIndex,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isOtpHidden = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingId = widget.bookingData['id'];
      if (bookingId != null) {
        Provider.of<BookingProvider>(
          context,
          listen: false,
        ).getBookingDetails(bookingId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Booking Details"),
            Expanded(
              child: Consumer<BookingProvider>(
                builder: (context, provider, child) {
                  if (provider.isDetailsLoading) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.primary,
                        size: 40,
                      ),
                    );
                  }

                  if (provider.detailsErrorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            provider.detailsErrorMessage!,
                            style: AppFontStyle.text_14_400(AppColors.red),
                            textAlign: TextAlign.center,
                          ),
                          hBox(16),
                          CustomButton(
                            text: "Retry",
                            width: 120,
                            height: 40,
                            onPressed: () {
                              final bookingId = widget.bookingData['id'];
                              if (bookingId != null) {
                                provider.getBookingDetails(bookingId);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  final data = provider.bookingDetails?.data;
                  if (data == null) {
                    return Center(
                      child: Text(
                        "No details found",
                        style: AppFontStyle.text_14_400(AppColors.grey),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bookingIdAndTotal(data),
                        hBox(20),
                        _serviceCards(data.items ?? []),
                        hBox(20),

                        // if (widget.tabIndex == 1 &&
                        //     data.serviceStartOtp != null) ...[
                        _otpSection(data.serviceStartOtp!),

                        //   hBox(20),
                        // ],
                        if (data.vendor != null) ...[
                          _serviceProvider(data.vendor!, provider),
                          hBox(20),
                        ],

                        _bookingDetailsSection(data),
                        hBox(20),
                        _paymentMethod(data),
                        hBox(20),
                        _paymentSummary(data, provider),
                        hBox(30),
                        // // if (widget.tabIndex == 2) ...[
                        // _getBottomButton(context),
                        // hBox(30),
                        // ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBottomButton(BuildContext context, BookingProvider provider) {
    // Upcoming bookings - Cancel Booking button (RED OUTLINED)
    // if (widget.tabIndex == 2) {

    if (provider.isCancelling) return const SizedBox.shrink();

    return CustomButton(
      width: MediaQuery.of(context).size.width,
      text: "Cancel Booking",
      isOutlined: true,
      color: AppColors.red,
      borderColor: AppColors.red,
      textStyle: AppFontStyle.text_16_600(AppColors.red),
      height: 52,
      onPressed: () {
        showCancelBookingDialog(context, widget.bookingData['id']);
      },
    );
  }

  Widget _bookingIdAndTotal(model.Data data) {
    Color statusColor = AppColors.primary;
    String statusText = data.status ?? "Unknown";

    if (statusText.toLowerCase() == 'cancelled') {
      statusColor = AppColors.red;
    } else if (statusText.toLowerCase() == 'pending') {
      statusColor = AppColors.orange;
    } else if (statusText.toLowerCase() == 'confirmed') {
      statusColor = AppColors.blue;
    } else if (statusText.toLowerCase() == 'ongoing' ||
        statusText.toLowerCase() == 'in progress') {
      statusColor = AppColors.orange;
      statusText = "in Progress";
    } else if (statusText.toLowerCase() == 'completed') {
      statusColor = AppColors.primary;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Booking ID", style: AppFontStyle.text_12_400(AppColors.grey)),
            hBox(4),
            Text(
              data.bookingCode ?? "N/A",
              style: AppFontStyle.text_16_600(AppColors.black),
            ),
            hBox(4),
            Container(
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  Get.capitalizeFirstLetter(statusText),
                  style: AppFontStyle.text_14_600(statusColor),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("Total", style: AppFontStyle.text_12_400(AppColors.grey)),
            hBox(4),
            Text(
              "${data.total ?? '0'}",
              style: AppFontStyle.text_16_700(AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _serviceCards(List<model.Items> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => hBox(12),
      itemBuilder: (context, index) {
        final item = items[index];
        return _serviceCard(
          item.serviceName ?? "Service",
          "${item.serviceItemTotal ?? item.unitPrice ?? '0'}",
          item.service?.serviceImage,
        );
      },
    );
  }

  Widget _serviceCard(String title, String price, String? imagePath) {
    final provider = Provider.of<BookingProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImage(
              path: provider.getFullImageUrl(imagePath),
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
                Text(price, style: AppFontStyle.text_14_600(AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpSection(String otp) {
    final otpDigits = otp.split('');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
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
              style: AppFontStyle.text_12_400(
                AppColors.lightGrey.withValues(alpha: 0.9),
              ),
            ),
            hBox(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 12),
                  width: MediaQuery.of(context).size.width * 0.76,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Wrap(
                        spacing: 12,
                        children: otpDigits
                            .map((digit) => _otpBox(digit))
                            .toList(),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isOtpHidden = !_isOtpHidden;
                          });
                        },
                        child: Text(
                          _isOtpHidden ? "Show" : "Hide",
                          style: AppFontStyle.text_14_600(AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(String digit) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        _isOtpHidden ? "*" : digit,
        style: AppFontStyle.text_20_600(AppColors.white),
      ),
    );
  }

  Widget _serviceProvider(model.Vendor vendor, BookingProvider provider) {
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
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(153, 221, 220, 220),
                ),
                child: Image.network(
                  provider.getFullImageUrl(vendor.proImg),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Icon(Icons.person_3_outlined);
                  },
                ),
              ),
              wBox(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${vendor.firstName ?? ''} ${vendor.lastName ?? ''}",
                      style: AppFontStyle.text_16_600(AppColors.black),
                    ),
                    hBox(2),
                    Text(
                      vendor.email ?? "Service Provider",
                      style: AppFontStyle.text_12_400(AppColors.grey),
                    ),
                  ],
                ),
              ),
              if (vendor.mobile != null)
                GestureDetector(
                  onTap: () {
                    // Implement call functionality if needed
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.phone, color: AppColors.white, size: 20),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bookingDetailsSection(model.Data data) {
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
          data.serviceDate != null
              ? DateFormat(
                  'dd-MM-yyyy',
                ).format(DateTime.parse(data.serviceDate!))
              : "N/A",
        ),
        hBox(12),
        _detailRow(Icons.access_time, "Time", data.serviceTime ?? "N/A"),
        hBox(12),
        _detailRow(
          Icons.location_on_outlined,
          "Address",
          data.address?.fullAddress ?? data.address?.streetAddress ?? "N/A",
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
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        wBox(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppFontStyle.text_12_400(AppColors.grey)),
              hBox(2),
              Text(value, style: AppFontStyle.text_14_500(AppColors.black)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentMethod(model.Data data) {
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
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.credit_card,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              wBox(12),
              Text(
                data.paymentMethod != null
                    ? Get.capitalizeFirstLetter(data.paymentMethod!)
                    : "Not specified",
                style: AppFontStyle.text_14_600(AppColors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentSummary(model.Data data, BookingProvider provider) {
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
          child: Column(
            children: [
              _summaryRow("Subtotal", "${data.subtotal ?? '0'}"),
              hBox(12),
              _summaryRow("Service Fee", "${data.serviceFee ?? '0'}"),
              hBox(16),
              Divider(
                color: AppColors.black.withValues(alpha: 0.10),
                thickness: 2,
              ),
              hBox(12),
              _summaryRow("Total", "${data.total ?? '0'}", isTotal: true),
              hBox(30),

              if (data.status?.toLowerCase() == "confirmed" ||
                  data.status?.toLowerCase() == "pending")
                _getBottomButton(context, provider),
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

  void showCancelBookingDialog(BuildContext context, int bookingId) {
    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );

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
                        maxLines: 2,
                        style: AppFontStyle.text_14_400(AppColors.darkText),
                      ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      "No",
                      style: AppFontStyle.text_14_500(AppColors.grey),
                    ),
                  ),
                  if (!provider.isCancelling)
                    TextButton(
                      onPressed: () async {
                        final success = await provider.cancelBooking(
                          bookingId,
                          context,
                        );
                        if (success) {
                          Navigator.pop(context);
                        }
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
