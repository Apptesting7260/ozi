import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/models/vendor_home_model.dart';
import '../../../bookings/booking details/view/vendor_booking_details_screen.dart';

typedef CallbackAction = void Function();

class RequestCard extends StatefulWidget {

  final VendorHomeRequests request;
  final CallbackAction onAccept;
  final CallbackAction onReject;

  const RequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: ()
      {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VendorBookingDetailsScreen( bookingId: widget.request.bookingId.toString(),),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Image.network(
                      "${AppUrls.imageBaseUrl}${widget.request.customerImage ?? ''}",
                      height: 36,
                      width: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.request.customerName != null &&
                                  widget.request.customerName!.isNotEmpty
                                  ? widget.request.customerName![0].toUpperCase()
                                  : "?",
                              style: AppFontStyle.text_14_600(AppColors.darkText),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                wBox(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.request.customerName??'',
                        style: AppFontStyle.text_14_600(AppColors.darkText),
                      ),
                      Text(
                        widget.request.bookingCode??'',
                        style: AppFontStyle.text_12_400(AppColors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.request.status?.toUpperCase()??'',
                    style: AppFontStyle.text_12_500(AppColors.purple),
                  ),
                ),
              ],
            ),

            hBox(12),

            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                wBox(6),
                Text(Get.getFormattedDate(widget.request.serviceDate??''), style: AppFontStyle.text_12_400(AppColors.grey)),
                wBox(12),
                Icon(Icons.access_time, size: 14, color: AppColors.grey),
                wBox(6),
                Text('${widget.request.serviceTime?.toString()}', style: AppFontStyle.text_12_400(AppColors.grey)),
              ],
            ),

            hBox(8),

            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.grey),
                wBox(6),
                Expanded(
                  child: Text(
                    widget.request.address??'',
                    style: AppFontStyle.text_12_400(AppColors.grey),
                    maxLines: 10,
                  ),
                ),
              ],
            ),

            hBox(14),
            Divider(thickness: 1, color: AppColors.black.withValues(alpha: 0.10), ),
            hBox(14),

            Row(
              children: [
                Text(
                  "\$${widget.request.totalAmount??''}",
                  style: AppFontStyle.text_14_600(AppColors.primary),
                ),
                const Spacer(),

                if (widget.request.status=='pending') ...[
                  CustomButton(
                    isLoading: widget.request.isLoadingReject,
                    height: 40,
                    width: 90,
                    // isOutlined: true,
                    text: "Reject",
                    textStyle: AppFontStyle.text_14_500(AppColors.white),
                    color: AppColors.red,
                    onPressed: widget.onReject,
                  ),
                  wBox(10),
                  CustomButton(
                    isLoading : widget.request.isLoadingAccept,
                    height: 40,
                    width: 90,
                    text: "Accept",
                    onPressed:widget.onAccept,
                  ),
                ] else if (widget.request.status=='confirmed')
                  GestureDetector(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: widget.request.customerPhone,
                      );
                      await launchUrl(launchUri);
                    },
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child:
                      Icon(Icons.call, color: Colors.white, size: 18),
                    ),
                  ),
              ],

            ),
          ],
        ),
      ),
    );
  }
}
