import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/pdf_file_viewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../provider/identity_verification_provider.dart';
import '../widget/vendor_custom_appbar.dart';

class IdentityVerificationScreen extends StatelessWidget {
  IdentityVerificationScreen({
    super.key,
    required this.isFromProfile,
    this.docImg,
    this.certificateImg,
  });

  final bool isFromProfile;
  String? docImg;
  String? certificateImg;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IdentityVerificationProvider(isFromProfile),
      child: _IdentityVerificationContent(
        isFromProfile,
        docImg,
        certificateImg,
      ),
    );
  }
}

class _IdentityVerificationContent extends StatelessWidget {
  _IdentityVerificationContent(
    this.isFromProfile,
    this.docImg,
    this.certificateImg,
  );

  final bool isFromProfile;
  String? docImg;
  String? certificateImg;



  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IdentityVerificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,

      // -------- BOTTOM BUTTON --------
      bottomNavigationBar:isFromProfile ? SizedBox.shrink()  : Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          isLoading: provider.submitLoading,
          height: 54,
          text: "Continue",
          borderRadius: BorderRadius.circular(60),
          color: provider.canContinue
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.6),
          onPressed: () {
            if (!provider.canContinue) return;
            provider.saveDocuments(isFromProfile, context);
          },
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                VendorCustomAppBar(
                  title: "Identity Verification",
                  columnChild: isFromProfile
                      ? Text('')
                      : Text(
                          "Step 4 of 6",
                          style: AppFontStyle.text_12_400(AppColors.grey),
                        ),
                ),
              ],
            ),

            hBox(20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          wBox(8),
                          Expanded(
                            child: Text(
                              "Your documents are securely stored and used only for verification purposes.",
                              maxLines: 3,
                              style: AppFontStyle.text_12_400(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    hBox(24),

                    // GOVERNMENT ID
                    _documentTile(
                      context: context,
                      title: "Government ID",
                      subtitle: "Driver's license or passport",
                      required: true,
                      uploaded: provider.isGovernmentUploaded,
                      iconPath: ImageConstants.governmentId,
                      onUpload: () =>
                         provider.showPickerOptions(context, provider.setGovernmentId),
                      remotePath: provider.govtIdImage,
                      imageUrl: '${AppUrls.imageBaseUrl}${docImg ?? ''}',
                      selectedFile: provider.governmentId,
                      provider: provider
                    ),

                    hBox(16),

                    // CERTIFICATIONS
                    _documentTile(
                      context: context,
                      title: "Certifications",
                      subtitle: "Professional certificates (optional)",
                      required: false,
                      uploaded: provider.isCertificationUploaded,
                      iconPath: ImageConstants.certificate,
                      onUpload: () =>
                          provider.showPickerOptions(context, provider.setCertification),
                      remotePath: provider.fetchedCertificate,
                      imageUrl:
                          '${AppUrls.imageBaseUrl}${certificateImg ?? ''}',
                      selectedFile: provider.certification,
                        provider: provider
                    ),

                    hBox(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- DOCUMENT TILE ----------------
  Widget _documentTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool required,
    required bool uploaded,
    required String iconPath,
    required String? remotePath,
    required VoidCallback onUpload,
    required String imageUrl,
    File? selectedFile,
    required IdentityVerificationProvider provider,

  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: uploaded ? AppColors.white : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: uploaded
              ? AppColors.primary
              : AppColors.grey.withValues(alpha: .2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 3,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomImage(
                    path: iconPath,
                    height: 20,
                    width: 20,
                    color: AppColors.primary,
                  ),
                ),
              ),
              wBox(10),

              // Title and Required
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: AppFontStyle.text_14_600(AppColors.darkText),
                        ),
                        if (required)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              "*Required",
                              style: AppFontStyle.text_12_400(AppColors.red),
                            ),
                          ),
                      ],
                    ),
                    hBox(2),
                    Text(
                      subtitle,
                      style: AppFontStyle.text_12_400(AppColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          hBox(12),


          if (selectedFile != null)
            selectedFile.path.endsWith(".pdf") ||
                selectedFile.path.endsWith(".doc") ||
                selectedFile.path.endsWith(".docx")

            // 📄 DOCUMENT VIEW
                ? Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: .15),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file, color: AppColors.primary),
                  wBox(10),
                  Expanded(
                    child: Text(
                      selectedFile.path.split('/').last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (title == "Government ID") {
                        provider.setGovernmentId(null);
                      } else {
                        provider.setCertification(null);
                      }
                    },
                    child: Icon(Icons.close, color: AppColors.red),
                  ),
                ],
              ),
            )

            // 🖼 IMAGE VIEW
                : Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.grey.withValues(alpha: .15),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      selectedFile,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      if (title == "Government ID") {
                        provider.setGovernmentId(null);
                      } else {
                        provider.setCertification(null);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )

          // else if (isFromProfile &&
          //     imageUrl.isNotEmpty &&
          //     imageUrl != AppUrls.imageBaseUrl)
          // //  SHOW NETWORK IMAGE IF NO LOCAL FILE
          //   Container(
          //     margin: const EdgeInsets.only(bottom: 10),
          //     height: 150,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(12),
          //       border: Border.all(
          //         color: AppColors.grey.withValues(alpha: .15),
          //       ),
          //     ),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(12),
          //       child: Image.network(
          //         imageUrl,
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   )

          else if (isFromProfile &&
              imageUrl.isNotEmpty &&
              imageUrl != AppUrls.imageBaseUrl)

            imageUrl.toLowerCase().endsWith(".pdf")

            //  PDF VIEW (NETWORK)
                ? Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: .15),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: AppColors.red),
                  wBox(10),
                  Expanded(
                    child: Text(
                      imageUrl.split('/').last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      provider.openPdf(imageUrl, context);
                    },
                    child: provider.isPdfLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Icon(Icons.open_in_new, color: AppColors.primary),
                  ),
                ],
              ),
            )

            // 🖼 IMAGE VIEW (NETWORK)
                : Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: .15),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullImageViewScreen(imageUrl: imageUrl),
                    ),
                  );
    },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          else
            SizedBox.shrink(),

          // Upload Status or Button
          if (uploaded)
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Row(
                children: [
                  Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Center(
                      child: CustomImage(
                        path: ImageConstants.rightIcon,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  wBox(6),
                  Text(
                    "Document uploaded",
                    style: AppFontStyle.text_12_400(AppColors.primary),
                  ),
                ],
              ),
            )
          else

            if(isFromProfile)
              SizedBox.shrink()
            else
            GestureDetector(
              onTap: onUpload,
              child: CustomPaint(
                painter: DottedBorderPainter(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  strokeWidth: 1.5,
                  gap: 4,
                  dashLength: 6,
                  borderRadius: 30,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImage(
                        path: ImageConstants.uploadImage,
                        height: 16,
                        width: 16,
                        color: AppColors.primary,
                      ),
                      wBox(6),
                      Text(
                        "Upload",
                        style: AppFontStyle.text_13_600(AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------- CUSTOM DOTTED BORDER PAINTER ----------------
class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final path = Path()..addRRect(rrect);

    final dashPath = _createDashedPath(path, dashLength, gap);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashLength, double dashGap) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final length = draw ? dashLength : dashGap;
        final end = distance + length;
        if (draw) {
          dest.addPath(
            metric.extractPath(
              distance,
              end > metric.length ? metric.length : end,
            ),
            Offset.zero,
          );
        }
        distance = end;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(DottedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
