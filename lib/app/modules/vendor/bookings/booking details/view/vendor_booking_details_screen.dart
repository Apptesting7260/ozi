



import 'package:ozi/app/core/constants/app_urls.dart';
import 'package:ozi/app/data/models/booking_detail_model.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/response/api_status.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../provider/vendor_booking_details_provider.dart';

class VendorBookingDetailsScreen extends StatelessWidget {
  final String bookingId;
  final int tabIndex;

  const VendorBookingDetailsScreen({
    super.key,
    required this.bookingId,
    this.tabIndex = 1
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VendorBookingDetailsProvider>(
      create: (context) => VendorBookingDetailsProvider(bookingId),
      child: Consumer<VendorBookingDetailsProvider>(
        builder: (context,provider,_) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(title: "Booking Details"),
                  switch (provider.homeModel.status) {
                    ApiStatus.loading =>
                        Expanded(child: const Center(child: CircularProgressIndicator())),

                    ApiStatus.completed =>
                        Expanded(
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

                                // if (tabIndex == 1) ...[
                                //   _otpSection(),
                                //   hBox(20),
                                // ],

                                _serviceProvider(
                                    provider.homeModel.data?.data?.user?.firstName??'',
                                    '${provider.homeModel.data?.data?.user?.countryCode??''}${provider.homeModel.data?.data?.user?.mobile??''}',
                                    provider.homeModel.data?.data?.user?.lastName??'',
                                    '${AppUrls.imageBaseUrl}${provider.homeModel.data?.data?.user?.proImg??''}',
                                ),
                                hBox(20),
                                _bookingDetailsSection(
                                  address: provider.homeModel.data?.data?.bookingCode??'',
                                  date: Get.getFormattedDate2(provider.homeModel.data?.data?.serviceDate??''),
                                  time:provider.homeModel.data?.data?.serviceTime?.from??''
                                ),
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

                    ApiStatus.error =>
                        Expanded(child: const Center(child: Text('Something went wrong'))),

                    _ =>
                    const SizedBox.shrink(),
                  },

                  // Bottom Button - Only for Upcoming (Cancel Booking in RED)
                  if (tabIndex == 2)
                    _bottomButton(context),
                ],
              ),
            ),
          );
        }
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
    return Consumer<VendorBookingDetailsProvider>(
      builder: (context,provider,_) {
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
                  booking?.bookingCode??'',
                  style: AppFontStyle.text_16_600(AppColors.black),
                ),

                // Show status for canceled bookings
                // if (tabIndex == 4) ...[
                //   hBox(4),
                //   Container(
                //     decoration: BoxDecoration(
                //       color: AppColors.red.withValues(alpha: 0.20),
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: Padding(
                //       padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                //       child: Text(
                //         "Cancelled",
                //         style: AppFontStyle.text_14_600(AppColors.red),
                //       ),
                //     ),
                //   ),
                // ],

                _StatusChip(status: booking?.status??'',)

                // Show status for ongoing bookings
                // if (tabIndex == 1) ...[
                //   hBox(4),
                //   Container(
                //     decoration: BoxDecoration(
                //       color: AppColors.orange.withValues(alpha: 0.20),
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: Padding(
                //       padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                //       child: Text(
                //         "in Progress",
                //         style: AppFontStyle.text_14_600(AppColors.orange),
                //       ),
                //     ),
                //   ),
                // ],
                //
                // if (tabIndex == 2) ...[
                //   hBox(4),
                //   Container(
                //     decoration: BoxDecoration(
                //       color: AppColors.blue.withValues(alpha: 0.20),
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: Padding(
                //       padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                //       child: Text(
                //         "Confirmed",
                //         style: AppFontStyle.text_14_600(AppColors.blue),
                //       ),
                //     ),
                //   ),
                // ],
                //
                // if (tabIndex == 3) ...[
                //   hBox(4),
                //   Container(
                //     decoration: BoxDecoration(
                //       color: AppColors.primary.withValues(alpha: 0.20),
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: Padding(
                //       padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                //       child: Text(
                //         "Completed",
                //         style: AppFontStyle.text_14_600(AppColors.primary),
                //       ),
                //     ),
                //   ),
                // ],
                //
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
                  "\$${booking?.total??''}",
                  style: AppFontStyle.text_16_700(AppColors.primary),
                ),
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _serviceCards(List<Items>? services) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services?.length??0,
      separatorBuilder: (_, __) => hBox(12),
      itemBuilder: (context, index) {
        return _serviceCard(
          services?[index].serviceName??'',
          services?[index].unitPrice??'',
          '${AppUrls.imageBaseUrl}${services?[index].image??''}',
        );
      },
    );
  }


  // Widget _serviceCards() {
  //   return Column(
  //     children: [
  //       _serviceCard(
  //         "Shirt Sleeve Shortening & Fitting...",
  //         "\$84.13",
  //       ),
  //       hBox(12),
  //       _serviceCard(
  //         "Shirt Sleeve Shortening & Fitting...",
  //         "\$84.13",
  //       ),
  //     ],
  //   );
  // }

  Widget _serviceCard(String title, String price,String image) {
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
              path: image,
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
      width: double.infinity,


      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),

      ),
      child: Container(
        padding:  EdgeInsets.all(16),
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
                  padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withValues(alpha: 0.15),
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
        digit,
        style: AppFontStyle.text_20_600(AppColors.white),
      ),
    );
  }


  Widget _serviceProvider(String customerName,String contact,String subHeading,String image) {
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
                  path: image,
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
              GestureDetector(
                onTap: (){
                  Get.dialCall(contact);
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _bookingDetailsSection({required String date,required String time,required String address}) {
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
          date,
        ),
        hBox(12),
        _detailRow(
          Icons.access_time,
          "Time",
          time,
        ),
        hBox(12),
        _detailRow(
          Icons.location_on_outlined,
          "Address",
          address,
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

    // Container(
    //   decoration: BoxDecoration(
    //     color: AppColors.red.withValues(alpha: 0.20),
    //     borderRadius: BorderRadius.circular(30),
    //   ),
    //   child: Padding(
    //     padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    //     child: Text(
    //       "Cancelled",
    //       style: AppFontStyle.text_14_600(AppColors.red),
    //     ),
    //   ),
    // )

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Text(
            text,
            style: AppFontStyle.text_14_600(textColor, fontFamily: AppFontFamily.medium)
        ),
      ),
    );
  }
}





//
// import 'package:ozi/app/core/constants/app_urls.dart';
//
// import '../../../../../core/appExports/app_export.dart';
// import '../../provider/vendor_mybookings_provider.dart';
// import '../provider/vendor_booking_details_provider.dart';
//
// class VendorBookingDetailsScreen extends StatelessWidget {
//   final String bookingId;
//
//   const VendorBookingDetailsScreen({super.key, required this.bookingId});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => VendorBookingDetailsProvider(bookingId),
//       child: const _BookingDetailsContent(),
//     );
//   }
// }
//
// class _BookingDetailsContent extends StatelessWidget {
//   const _BookingDetailsContent();
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<VendorBookingDetailsProvider>();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       // bottomNavigationBar: _buildBottomButton(context, provider),
//
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// APP BAR
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF5F5F5),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Icon(Icons.arrow_back, size: 20),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     "Booking Details",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               /// BOOKING ID + TOTAL
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Booking ID",
//                         style: TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                       Text(
//                         provider.homeModel.data?.data?.bookingCode??'',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       const Text(
//                         "Total",
//                         style: TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                       Text(
//                         "\$${provider.homeModel.data?.data?.total??''}",
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF00BFA6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 8),
//
//               _StatusChip(status: provider.homeModel.data?.data?.status??''),
//
//               const SizedBox(height: 16),
//
//               /// SERVICE
//               Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       "${AppUrls.imageBaseUrl}${provider.homeModel.data?.data?.user?.proImg??''}",
//                       height: 60,
//                       width: 60,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           provider.homeModel.data?.data?.items?.first.serviceName??'',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF1A1A1A),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "\$${provider.homeModel.data?.data?.total??''}",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF00BFA6),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               /// CUSTOMER DETAILS
//               _sectionTitle("Customer Details"),
//               const SizedBox(height: 12),
//
//               // Row(
//               //   children: [
//               //     const CircleAvatar(
//               //       radius: 22,
//               //       backgroundImage:
//               //       NetworkImage("https://i.pravatar.cc/150?img=3"),
//               //     ),
//               //     const SizedBox(width: 12),
//               //     Expanded(
//               //       child: Column(
//               //         crossAxisAlignment: CrossAxisAlignment.start,
//               //         children: [
//               //           Text(
//               //             booking.name,
//               //             style: const TextStyle(
//               //               fontSize: 14,
//               //               fontWeight: FontWeight.w600,
//               //               color: Color(0xFF1A1A1A),
//               //             ),
//               //           ),
//               //           Text(
//               //             booking.phone,
//               //             style: const TextStyle(
//               //               fontSize: 12,
//               //               color: Colors.grey,
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //     GestureDetector(
//               //       onTap: provider.callCustomer,
//               //       child: Container(
//               //         height: 40,
//               //         width: 40,
//               //         decoration: const BoxDecoration(
//               //           color: Color(0xFF00BFA6),
//               //           shape: BoxShape.circle,
//               //         ),
//               //         child: const Icon(
//               //           Icons.call,
//               //           color: Colors.white,
//               //           size: 18,
//               //         ),
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               //
//               // const SizedBox(height: 24),
//               //
//               // /// BOOKING DETAILS
//               // _sectionTitle("Booking Details"),
//               // const SizedBox(height: 12),
//               //
//               // _infoRow("Date", booking.date),
//               // _infoRow("Time", booking.time),
//               // _infoRow("Address", booking.address),
//               //
//               // const SizedBox(height: 16),
//               //
//               // /// NAVIGATE BUTTON
//               // SizedBox(
//               //   width: double.infinity,
//               //   height: 46,
//               //   child: OutlinedButton(
//               //     onPressed: provider.navigateToCustomer,
//               //     style: OutlinedButton.styleFrom(
//               //       side: const BorderSide(color: Color(0xFF00BFA6)),
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(30),
//               //       ),
//               //     ),
//               //     child: const Text(
//               //       "Navigate to Customer",
//               //       style: TextStyle(
//               //         fontSize: 14,
//               //         fontWeight: FontWeight.w600,
//               //         color: Color(0xFF00BFA6),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               //
//               // const SizedBox(height: 24),
//               //
//               // /// PAYMENT METHOD
//               // _sectionTitle("Payment Method"),
//               // const SizedBox(height: 8),
//               // Text(
//               //   booking.paymentMethod,
//               //   style: const TextStyle(
//               //     fontSize: 14,
//               //     color: Color(0xFF1A1A1A),
//               //   ),
//               // ),
//               //
//               // const SizedBox(height: 24),
//               //
//               // /// PAYMENT SUMMARY
//               // _sectionTitle("Payment Summary"),
//               // const SizedBox(height: 12),
//               //
//               // _amountRow("Subtotal", booking.price),
//               // _amountRow("Service Fee", booking.serviceFee),
//               // const Divider(),
//               // _amountRow("Total", booking.total, bold: true),
//               //
//               // const SizedBox(height: 80),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Widget? _buildBottomButton(
//   //     BuildContext context,
//   //     VendorBookingDetailsProvider provider,
//   //     ) {
//   //   if (provider.isOngoing) {
//   //     return Padding(
//   //       padding: const EdgeInsets.all(16),
//   //       child: SizedBox(
//   //         width: double.infinity,
//   //         height: 54,
//   //         child: ElevatedButton(
//   //           onPressed: provider.isProcessing
//   //               ? null
//   //               : () => provider.completeJob(context),
//   //           style: ElevatedButton.styleFrom(
//   //             backgroundColor: const Color(0xFF00BFA6),
//   //             shape: RoundedRectangleBorder(
//   //               borderRadius: BorderRadius.circular(60),
//   //             ),
//   //             elevation: 0,
//   //           ),
//   //           child: provider.isProcessing
//   //               ? const SizedBox(
//   //             height: 20,
//   //             width: 20,
//   //             child: CircularProgressIndicator(
//   //               color: Colors.white,
//   //               strokeWidth: 2,
//   //             ),
//   //           )
//   //               : const Text(
//   //             "Complete Job",
//   //             style: TextStyle(
//   //               fontSize: 16,
//   //               fontWeight: FontWeight.w600,
//   //               color: Colors.white,
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //   }
//   //
//   //   if (provider.isUpcoming) {
//   //     return Padding(
//   //       padding: const EdgeInsets.all(16),
//   //       child: SizedBox(
//   //         width: double.infinity,
//   //         height: 54,
//   //         child: ElevatedButton(
//   //           onPressed: provider.isProcessing
//   //               ? null
//   //               : () => provider.startJob(context),
//   //           style: ElevatedButton.styleFrom(
//   //             backgroundColor: const Color(0xFF00BFA6),
//   //             shape: RoundedRectangleBorder(
//   //               borderRadius: BorderRadius.circular(60),
//   //             ),
//   //             elevation: 0,
//   //           ),
//   //           child: provider.isProcessing
//   //               ? const SizedBox(
//   //             height: 20,
//   //             width: 20,
//   //             child: CircularProgressIndicator(
//   //               color: Colors.white,
//   //               strokeWidth: 2,
//   //             ),
//   //           )
//   //               : const Text(
//   //             "Start Job",
//   //             style: TextStyle(
//   //               fontSize: 16,
//   //               fontWeight: FontWeight.w600,
//   //               color: Colors.white,
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //   }
//   //
//   //   return null;
//   // }
//
//   Widget _sectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         color: Color(0xFF1A1A1A),
//       ),
//     );
//   }
//
//   Widget _infoRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 70,
//             child: Text(
//               title,
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Color(0xFF1A1A1A),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _amountRow(String title, double amount, {bool bold = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 13, color: Colors.grey),
//           ),
//           Text(
//             "\$${amount.toStringAsFixed(2)}",
//             style: TextStyle(
//               fontSize: bold ? 14 : 13,
//               fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
//               color: const Color(0xFF1A1A1A),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
// }
// class _StatusChip extends StatelessWidget {
//   final String status;
//
//   const _StatusChip({required this.status});
//
//   @override
//   Widget build(BuildContext context) {
//     Color bg;
//     String text;
//     Color textColor;
//
//     switch (status) {
//       case "in_progress":
//         bg = Colors.orange.withValues(alpha: 0.15);
//         text = "In Progress";
//         textColor = Colors.orange;
//         break;
//       case "confirmed":
//         bg = Colors.blue.withValues(alpha: 0.15);
//         text = "Confirmed";
//         textColor = Colors.blue;
//         break;
//       case "completed":
//         bg = Colors.green.withValues(alpha: 0.15);
//         text = "Completed";
//         textColor = Colors.green;
//         break;
//       case "cancelled":
//         bg = Colors.red.withValues(alpha: 0.15);
//         text = "Cancelled";
//         textColor = Colors.red;
//         break;
//       default:
//         bg = const Color(0xFFF5F5F5);
//         text = status;
//         textColor = const Color(0xFF1A1A1A);
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         text,
//         style: AppFontStyle.text_11_500(AppColors.black, fontFamily: AppFontFamily.medium)
//       ),
//     );
//   }
// }
