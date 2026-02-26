import 'package:intl/intl.dart';
import 'package:ozi/app/modules/user/singleService/screen/singleservicescreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../provider/booking_provider.dart';
import '../../model/bookingdetailsmodel.dart' as model;
import 'package:ozi/app/shared/widgets/custom_date_picker.dart';

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

                  return RefreshIndicator(
                    onRefresh: () async {
                      final bookingId = widget.bookingData['id'];
                      if (bookingId != null) {
                        await provider.getBookingDetails(bookingId);
                      }
                    },
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.all(16),
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

  Widget _getBottomRescheduleButton(
    BuildContext context,
    BookingProvider provider,
  ) {
    return CustomButton(
      width: MediaQuery.of(context).size.width,
      isOutlined: true,
      borderColor: AppColors.primary,
      height: 52,
      onPressed: () {
        showRescheduleBottomSheet(context, widget.bookingData['id'], provider);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.refresh, color: AppColors.primary, size: 20),
          wBox(10),
          Text(
            "Reschedule Booking",
            style: AppFontStyle.text_16_600(AppColors.primary),
          ),
        ],
      ),
    );
  }

  void showRescheduleBottomSheet(
    BuildContext context,
    int bookingId,
    BookingProvider provider,
  ) {
    provider.fetchAvailability(bookingId.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return ListenableBuilder(
          listenable: provider,
          builder: (context, child) {
            final times = provider.availableTimesForSelectedDay;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  hBox(20),
                  Center(
                    child: Text(
                      "Reschedule Booking",
                      style: AppFontStyle.text_20_600(AppColors.black),
                    ),
                  ),
                  hBox(24),
                  Text(
                    'Select Date',
                    style: AppFontStyle.text_16_600(AppColors.black),
                  ),
                  hBox(16),
                  if (provider.isAvailabilityLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  else
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.quickDates.length + 1,
                        itemBuilder: (context, index) {
                          if (index == provider.quickDates.length) {
                            return _buildMoreDatesButton(context, provider);
                          }
                          return _buildDateItem(provider, index);
                        },
                      ),
                    ),
                  hBox(24),
                  Text(
                    'Select Time',
                    style: AppFontStyle.text_16_600(AppColors.black),
                  ),
                  hBox(16),
                  if (times.isEmpty)
                    Center(
                      child: Text(
                        'No service available for this day',
                        style: AppFontStyle.text_14_400(AppColors.red),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.2,
                          ),
                      itemCount: times.length,
                      itemBuilder: (context, index) {
                        final time = times[index];
                        final isSelected =
                            provider.selectedRescheduleTime == time;
                        return GestureDetector(
                          onTap: () => provider.selectRescheduleTime(time),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              time,
                              style: AppFontStyle.text_14_600(
                                isSelected ? Colors.white : Colors.black,
                                fontFamily: AppFontFamily.semiBold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  hBox(32),
                  CustomButton(
                    isLoading: provider.isScheduleAgain,
                    text: "Submit",
                    color: provider.selectedRescheduleTime != null
                        ? AppColors.primary
                        : AppColors.lightGrey2,
                    onPressed: provider.selectedRescheduleTime != null
                        ? () {
                            provider.rescheduleBooking(
                              widget.bookingData['id'],
                              context,
                            );
                          }
                        : null,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showRatingBottomSheet(
    BuildContext context,
    model.Vendor vendor,
    int bookingId,
    BookingProvider provider,
  ) {
    int selectedRating = 0;
    final TextEditingController reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey2,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  hBox(20),
                  Text(
                    "Rate this Provider",
                    style: AppFontStyle.text_20_600(AppColors.black),
                  ),
                  hBox(24),
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: NetworkImage(
                      provider.getFullImageUrl(vendor.proImg),
                    ),
                    backgroundColor: AppColors.lightGrey,
                    child: vendor.proImg != null
                        ? null
                        : Icon(
                            Icons.person,
                            size: 40.r,
                            color: AppColors.black,
                          ),
                  ),
                  hBox(12),
                  Text(
                    "${vendor.firstName ?? ''} ${vendor.lastName ?? ''}",
                    style: AppFontStyle.text_16_600(AppColors.black),
                  ),
                  hBox(24),
                  Text(
                    "What is you rate?",
                    style: AppFontStyle.text_16_600(AppColors.black),
                  ),
                  hBox(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            size: 36.w,
                            color: index < selectedRating
                                ? AppColors.orange
                                : AppColors.lightGrey3,
                          ),
                        ),
                      );
                    }),
                  ),
                  hBox(24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "How was your experience?",
                      style: AppFontStyle.text_16_600(AppColors.black),
                    ),
                  ),
                  hBox(16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: TextField(
                      controller: reviewController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Write your review...",
                        hintStyle: AppFontStyle.text_14_400(
                          AppColors.lightGrey3,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  hBox(32),
                  ListenableBuilder(
                    listenable: provider,
                    builder: (context, child) {
                      return CustomButton(
                        isLoading: provider.isReviewLoading,
                        text: "Submit",
                        onPressed: selectedRating > 0
                            ? () async {
                                final success = await provider.submitReview(
                                  vendor.id.toString(),
                                  selectedRating.toString(),
                                  reviewController.text.toString(),
                                );
                                if (success) {
                                  Navigator.pop(context);
                                }
                              }
                            : null,
                      );
                    },
                  ),
                  hBox(10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _getRatingsButton(BuildContext context, BookingProvider provider) {
    final data = provider.bookingDetails?.data;
    if (data == null || data.vendor == null) return const SizedBox.shrink();

    return CustomButton(
      width: MediaQuery.of(context).size.width,
      isOutlined: true,
      color: AppColors.primary,
      borderColor: AppColors.primary,
      textStyle: AppFontStyle.text_16_600(AppColors.primary),
      height: 52,
      onPressed: () {
        showRatingBottomSheet(context, data.vendor!, data.id!, provider);
      },
      child: Text(
        "Rate this Provider",
        style: AppFontStyle.text_16_600(AppColors.primary),
      ),
    );
  }

  Widget _buildDateItem(BookingProvider provider, int index) {
    final date = DateTime.now().add(Duration(days: index));
    final isSelected =
        provider.selectedRescheduleDate.day == date.day &&
        provider.selectedRescheduleDate.month == date.month &&
        provider.selectedRescheduleDate.year == date.year;

    return GestureDetector(
      onTap: () => provider.selectRescheduleDate(date),
      child: Container(
        width: 70,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.quickDates[index]['day']!,
              style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
            ),
            hBox(4),
            Text(
              provider.quickDates[index]['date']!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(
              provider.quickDates[index]['month']!,
              style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreDatesButton(BuildContext context, BookingProvider provider) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await CustomDatePicker.showServiceDatePicker(
          context,
          initialDate: provider.selectedRescheduleDate,
        );
        if (pickedDate != null) {
          provider.selectRescheduleDate(pickedDate);
        }
      },
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.calendar_today, size: 20, color: Colors.grey),
            SizedBox(height: 4),
            Text(
              'More\nDates',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
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
              data.total ?? '0',
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
          item.serviceItemTotal ?? item.unitPrice ?? '0',
          item.service?.serviceImage,
          index: index,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
        );
      },
    );
  }

  Widget _serviceCard(
    String title,
    String price,
    String? imagePath, {
    required int index,
    int? quantity,
    String? unitPrice,
  }) {
    final provider = Provider.of<BookingProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => singleServiceScreen(
              serviceId:
                  provider.bookingDetails?.data?.items?[index].service?.id ??
                  provider.bookingDetails?.data?.items?[index].serviceId ??
                  0,
              isCart: false,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.containerBorder.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImage(
                path: provider.getFullImageUrl(imagePath),
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
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.text_14_600(AppColors.black),
                  ),
                  hBox(4),
                  // Row(
                  //   children: [
                  //     if (unitPrice != null)
                  //       Text(
                  //         "\$$unitPrice",
                  //         style: AppFontStyle.text_12_400(AppColors.grey),
                  //       ),
                  //     if (unitPrice != null && quantity != null)
                  //       Text(
                  //         " x $quantity",
                  //         style: AppFontStyle.text_12_600(AppColors.black),
                  //       ),
                  //   ],
                  // ),
                ],
              ),
            ),
            Text(
              "\$$price",
              style: AppFontStyle.text_14_700(AppColors.primary),
            ),
          ],
        ),
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
              if (provider.bookingDetails?.data?.status?.toLowerCase() !=
                      "rejected" &&
                  provider.bookingDetails?.data?.status?.toLowerCase() !=
                      "cancelled") ...[
                if (vendor.mobile != null)
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse("tel:${vendor.mobile}"));
                    },
                    child: Container(
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
                  ),
                wBox(12),
                GestureDetector(
                  onTap: () {
                    provider.sendMessage(vendor.id?.toString() ?? '');
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
              ],
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
        _detailRow(
          Icons.access_time,
          "Time",
          data.serviceTime != null
              ? (data.serviceTime!.to != null &&
                        data.serviceTime!.to!.isNotEmpty)
                    ? "${data.serviceTime!.from ?? 'N/A'} - ${data.serviceTime!.to}"
                    : data.serviceTime!.from ?? 'N/A'
              : "N/A",
        ),
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
                    ? Get.capitalizeFirstLetter(
                        data.paymentMethod!.replaceAll('_', ' '),
                      )
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
              _summaryRow("Subtotal", "\$${data.subtotal ?? '0'}"),
              hBox(12),
              _summaryRow("Service Fee", "\$${data.serviceFee ?? '0'}"),
              data.discountAmount != null ? hBox(16) : SizedBox.shrink(),
              if (data.discountAmount != null &&
                  double.parse(data.discountAmount!) > 0)
                _summaryRow("Discount", "-\$${data.discountAmount}"),
              hBox(16),

              Divider(
                color: AppColors.black.withValues(alpha: 0.10),
                thickness: 2,
              ),
              hBox(12),
              _summaryRow("Total", "\$${data.total ?? '0'}", isTotal: true),
              hBox(30),

              if (data.status?.toLowerCase() == "confirmed" ||
                  data.status?.toLowerCase() == "pending")
                _getBottomButton(context, provider),
              hBox(15),
              if (data.status?.toLowerCase() == "pending")
                _getBottomRescheduleButton(context, provider),
              hBox(15),
              if (data.status?.toLowerCase() == "completed")
                _getRatingsButton(context, provider),
              // _getBottomCancelButton(context, provider),
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
