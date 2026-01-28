import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/models/vendor_home_model.dart';

typedef CallbackAction = void Function();

class RequestCard extends StatelessWidget {

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
  Widget build(BuildContext context) {

    return Container(
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
                  child: CustomImage(
                    path: "${AppUrls.imageBaseUrl}${request.customerImage??''}",
                    height: 36,
                    width: 36,
                  ),
                ),
              ),

              wBox(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.customerName??'',
                      style: AppFontStyle.text_14_600(AppColors.darkText),
                    ),
                    Text(
                      request.bookingCode??'',
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
                  request.status?.toUpperCase()??'',
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
              Text(Get.getFormattedDate(request.serviceDate??''), style: AppFontStyle.text_12_400(AppColors.grey)),
              wBox(12),
              Icon(Icons.access_time, size: 14, color: AppColors.grey),
              wBox(6),
              Text('${request.serviceTime?.from?.toString()} - ${request.serviceTime?.to?.toString()}', style: AppFontStyle.text_12_400(AppColors.grey)),
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
                  request.address??'',
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
                "\$${request.totalAmount??''}",
                style: AppFontStyle.text_14_600(AppColors.primary),
              ),
              const Spacer(),

              if (request.status=='pending') ...[
                CustomButton(
                  isLoading: request.isLoadingReject,
                  height: 40,
                  width: 90,
                  // isOutlined: true,
                  text: "Reject",
                  textStyle: AppFontStyle.text_14_500(AppColors.white),
                  color: AppColors.red,
                  onPressed: onReject,
                ),
                wBox(10),
                CustomButton(
                  isLoading : request.isLoadingAccept,
                  height: 40,
                  width: 90,
                  text: "Accept",
                  onPressed:onAccept,
                ),
              ] else
                GestureDetector(
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: request.customerPhone,
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
    );
  }
}
