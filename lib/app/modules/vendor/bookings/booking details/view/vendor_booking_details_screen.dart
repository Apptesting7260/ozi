import 'package:ozi/app/core/constants/app_urls.dart';
import 'package:ozi/app/data/models/booking_detail_model.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/response/api_status.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../user/booking/provider/booking_provider.dart';
import '../provider/vendor_booking_details_provider.dart';

class VendorBookingDetailsScreen extends StatelessWidget {
  final String bookingId;
  final int tabIndex;

  const VendorBookingDetailsScreen({
    super.key,
    required this.bookingId,
    this.tabIndex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    return ChangeNotifierProvider<VendorBookingDetailsProvider>(
      create: (context) => VendorBookingDetailsProvider(bookingId),
      child: Builder(
        builder: (context) {
          final provider = context.watch<VendorBookingDetailsProvider>();

          final bookingDateString =
              provider.homeModel.data?.data?.serviceDate ?? '';

          DateTime? bookingDate;
          if (bookingDateString.isNotEmpty) {
            bookingDate = DateTime.parse(bookingDateString);
          }

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final bookingDay = bookingDate != null
              ? DateTime(bookingDate.year, bookingDate.month, bookingDate.day)
              : null;

          final isTodayBooking = bookingDay != null && bookingDay == today;
          final data = provider.homeModel?.data?.data;
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(title: "Booking Details"),
                  switch (provider.homeModel.status) {
                    ApiStatus.loading => Expanded(
                      child: const Center(child: CircularProgressIndicator()),
                    ),

                    ApiStatus.completed => Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _bookingIdAndTotal(),
                            hBox(20),
                            _serviceCards(provider.homeModel.data?.data?.items),
                            hBox(20),
                            _serviceProvider(
                              provider.homeModel.data?.data?.user?.firstName ??
                                  '',
                              '${provider.homeModel.data?.data?.user?.countryCode ?? ''}${provider.homeModel.data?.data?.user?.mobile ?? ''}',
                              provider.homeModel.data?.data?.user?.lastName ??
                                  '',
                              '${AppUrls.imageBaseUrl}${provider.homeModel.data?.data?.user?.proImg ?? ''}',
                              provider.homeModel.data?.data?.status ?? '',
                              provider.homeModel.data?.data?.user?.id ?? '',
                              bookingProvider,
                            ),
                            hBox(20),
                            _bookingDetailsSection(

                              address: [
                                data?.streetAddress,
                                data?.apartment,
                                data?.city,
                                data?.zipCode,
                                data?.country,
                              ]
                                  .where((e) => e != null && e.trim().isNotEmpty)
                                  .join(', '),
                              date: Get.getFormattedDate2(
                                provider.homeModel.data?.data?.serviceDate ??
                                    '',
                              ),
                              time:
                                  provider.homeModel.data?.data?.serviceTime ??
                                  '',
                            ),
                            hBox(20),
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: OutlinedButton(
                                onPressed: () {
                                  //
                                  // final encodedAddress = Uri.encodeComponent(provider.homeModel.data?.data?.address?.fullAddress??'');
                                  //
                                  // final url = "https://www.google.com/maps/search/$encodedAddress";
                                  //
                                  // Navigator.pushNamed(
                                  //   context,
                                  //   AppRoutes.commonScreen,
                                  //   arguments: CommonScreenArgs(
                                  //     type: "Navigate to Customer",
                                  //     url: url,
                                  //   ),
                                  // );
                                  provider.navigateToCustomer();
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0x1A13AC6F),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor: Color(0x1A13AC6F),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomImage(
                                      path: ImageConstants.navigationIcon,
                                    ),
                                    wBox(10),
                                    const Text(
                                      "Navigate to Customer",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF13AC6F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            hBox(20),
                            _paymentMethod(
                              provider.homeModel.data?.data?.paymentMethod ??
                                  "",
                            ),
                            hBox(20),
                            _paymentSummary(
                              serviceFee:
                                  provider.homeModel.data?.data?.serviceFee ??
                                  '',
                              subTotal:
                                  provider.homeModel.data?.data?.subtotal ?? '',
                              discount:
                                  provider.homeModel.data?.data?.discountAmount ??
                                  '',
                              total: provider.homeModel.data?.data?.total ?? '',
                            ),

                            hBox(10),

                            if (provider.homeModel.data?.data?.status ==
                                    'ongoing' &&
                                provider.homeModel.data?.data?.paymentMethod ==
                                    'cash') ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.orange.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: provider.isCashCollected,
                                      activeColor: Colors.orange,
                                      onChanged: (value) {
                                        provider.setCashCollected(
                                          value ?? false,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        "Please collect the payment from the customer.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            hBox(10),

                            if (provider.homeModel.data?.data?.status == 'confirmed' && !isTodayBooking)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.orange.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.orange),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "You can start this job on the booking date only",
                                        style: TextStyle(
                                          color: Colors.orange.shade800,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            hBox(5),

                            if (provider.homeModel.data?.data?.status == 'confirmed') ...[
                              CustomButton(
                                isLoading: provider.otpVerifyLoading,
                                text: 'Start Job',
                                onPressed: isTodayBooking
                                    ? () {
                                  _showOtpBottomSheet(context, provider, bookingId);
                                }
                                    : null,
                                color: isTodayBooking ? AppColors.primary : AppColors.grey,
                              ),

                            ],

                            if (provider.homeModel.data?.data?.status ==
                                'ongoing')
                              CustomButton(
                                isLoading: provider.completeJobLoading,
                                text: 'Complete Job',
                                onPressed: provider.completeJobLoading
                                    ? null
                                    : () async {
                                        final data =
                                            provider.homeModel.data?.data;
                                        final isCashPayment =
                                            data?.paymentMethod == 'cash';
                                        final isCollected =
                                            provider.isCashCollected;

                                        if (isCashPayment && !isCollected) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              showCloseIcon: true,
                                              closeIconColor: Colors.white,
                                              content: Text(
                                                "Please confirm that you have collected the cash payment before completing the job.",
                                              ),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          );
                                          return;
                                        }

                                        final success = await provider
                                            .completeTheJob(bookingId);

                                        if (success && context.mounted) {
                                          Navigator.pop(context, true);
                                        }
                                      },
                              ),

                            if (tabIndex == 2) hBox(100) else hBox(20),
                          ],
                        ),
                      ),
                    ),

                    ApiStatus.error => Expanded(
                      child: const Center(child: Text('Something went wrong')),
                    ),

                    _ => const SizedBox.shrink(),
                  },

                  // Bottom Button - Only for Upcoming (Cancel Booking in RED)
                  if (tabIndex == 2) _bottomButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOtpBottomSheet(
    BuildContext context,
    VendorBookingDetailsProvider provider,
    String bookingId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return  ChangeNotifierProvider.value(
            value: provider,
            child:  Consumer<VendorBookingDetailsProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4,
                    width: 50,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    "Verify OTP",
                    style: AppFontStyle.text_18_600(AppColors.black),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Ask the customer for the 4-digit OTP to start the job.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  /// OTP FIELD
                  PinCodeTextField(
                    appContext: context,
                    controller: provider.pinController,
                    autoDisposeControllers: false,
                    length: 4,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    enableActiveFill: true,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      fieldHeight: 55,
                      fieldWidth: 55,
                      activeFillColor: AppColors.fieldBgColor,
                      inactiveFillColor: AppColors.fieldBgColor,
                      selectedFillColor: AppColors.fieldBgColor,
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.transparent,
                      selectedColor: AppColors.primary,
                      borderWidth: 0,
                    ),
                    onChanged: (_) {
                      if (provider.errorMessage != null) {
                        provider.updateErrorMessage(null);
                      }
                    },
                  ),

                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage!,
                      style: AppFontStyle.text_14_400(Colors.red),
                    ),
                  ],

                  const SizedBox(height: 24),

                  CustomButton(
                    isLoading: provider.otpVerifyLoading,
                    text: "Verify & Start Job",
                    onPressed: () async {
                      final success = await provider.verifyOtp(bookingId);

                      if (success) {
                        Navigator.pop(context); // ✅ only close on success
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        )
        );
      },
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
      child: SafeArea(top: false, child: _getBottomButton(context)),
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
    return Consumer<VendorBookingDetailsProvider>(
      builder: (context, provider, _) {
        final booking = provider.homeModel.data?.data;
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
                  booking?.bookingCode ?? '',
                  style: AppFontStyle.text_16_600(AppColors.black),
                ),

                _StatusChip(status: booking?.status ?? ''),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Total", style: AppFontStyle.text_12_400(AppColors.grey)),
                hBox(4),
                Text(
                  "\$${booking?.total ?? ''}",
                  style: AppFontStyle.text_16_700(AppColors.primary),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _serviceCards(List<Items>? services) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services?.length ?? 0,
      separatorBuilder: (_, __) => hBox(12),
      itemBuilder: (context, index) {
        return _serviceCard(
          services?[index].quantity ?? '',
          services?[index].serviceName ?? '',
          services?[index].unitPrice ?? '',
          '${AppUrls.imageBaseUrl}${services?[index].image ?? ''}',
        );
      },
    );
  }

  Widget _serviceCard(
    String quantity,
    String title,
    String price,
    String image,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Selector<VendorBookingDetailsProvider, String>(
              selector: (_, p) => p.homeModel.data?.data?.user?.proImg ?? '',
              builder: (_, img, __) {
                return CustomImage(
                  path: image,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                );
              },
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "Qty: $quantity",
              style: AppFontStyle.text_14_600(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceProvider(
    String customerName,
    String contact,
    String subHeading,
    String image,
    String status,
    String id,
    bookingProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer Details",
          style: AppFontStyle.text_16_600(AppColors.black),
        ),
        hBox(12),
        Container(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _nameAvatar(customerName);
                        },
                      )
                    : _nameAvatar(customerName),
              ),
              wBox(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: AppFontStyle.text_16_600(AppColors.black),
                    ),
                    hBox(2),
                    Text(
                      subHeading,
                      style: AppFontStyle.text_12_400(AppColors.grey),
                    ),
                  ],
                ),
              ),
              if (status != 'rejected' && status != 'cancelled' && status != 'completed' && status != 'pending' ) ...[
                GestureDetector(
                  onTap: () {
                    bookingProvider.sendMessage(id.toString());
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.message,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),

                wBox(12),

                GestureDetector(
                  onTap: () {
                    Get.dialCall(contact);
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

              // else
              //   SizedBox.shrink()
            ],
          ),
        ),
      ],
    );
  }

  Widget _bookingDetailsSection({
    required String date,
    required String time,
    required String address,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Booking Details",
          style: AppFontStyle.text_16_600(AppColors.black),
        ),
        hBox(12),
        _detailRow(Icons.calendar_today_outlined, "Date", date),
        hBox(12),
        _detailRow(Icons.access_time, "Time", time),
        hBox(12),
        _detailRow(Icons.location_on_outlined, "Address", address),
      ],
    );
  }

  Widget _nameAvatar(String name) {
    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: AppFontStyle.text_18_600(AppColors.primary),
      ),
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
              Text(
                  maxLines: 2,
                  value, style: AppFontStyle.text_14_500(AppColors.black)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentMethod(String paymentMethod) {
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

                child: paymentMethod == "pay_online"
                    ? Icon(
                        Icons.credit_card,
                        color: AppColors.primary,
                        size: 24,
                      )
                    : SvgPicture.asset(ImageConstants.cash),
              ),
              wBox(12),

              Text(
                paymentMethod == "pay_online" ? "Online Payment" : "Cash",
                style: AppFontStyle.text_14_600(AppColors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentSummary({
    required String subTotal,
    required String serviceFee,
    required String discount,
    required String total,
  }) {
    final discountValue = double.tryParse(discount ?? "0") ?? 0;
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
              _summaryRow("Subtotal", "\$$subTotal"),
              hBox(12),
              _summaryRow("Service Fee", "\$$serviceFee"),
              hBox(12),
              discountValue == 0
                  ? SizedBox.shrink()
                  : _summaryRow("Discount", "\$$discountValue"),
              discountValue == 0 ? SizedBox.shrink() : hBox(16),
              Divider(
                color: AppColors.black.withValues(alpha: 0.10),
                thickness: 2,
              ),
              hBox(12),
              _summaryRow("Total", "\$$total", isTotal: true),
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
        bg = AppColors.white;
        text = status;
        textColor = AppColors.black;
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Text(
          text,
          style: AppFontStyle.text_14_600(
            textColor,
            fontFamily: AppFontFamily.medium,
          ),
        ),
      ),
    );
  }
}
