import 'package:image_picker/image_picker.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/ready_to_go_livescreen.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../provider/identity_verification_provider.dart';
import 'package:dotted_border/dotted_border.dart';


class IdentityVerificationScreen extends StatelessWidget {
  const IdentityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IdentityVerificationProvider(),
      child: const _IdentityVerificationContent(),
    );
  }
}

class _IdentityVerificationContent extends StatelessWidget {
  const _IdentityVerificationContent();

  Future<void> _pickFile(
      BuildContext context,
      void Function(File) onSelected,
      ) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      onSelected(File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IdentityVerificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          height: 54,
          text: "Continue",
          borderRadius: BorderRadius.circular(60),
          color: provider.canContinue
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.35),
          onPressed: () {
            if (!provider.canContinue) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadyToGoLiveScreen(),
              ),
            );
          },
        ),


      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(title: "Identity Verification"),
              hBox(6),
              Center(
                child: Text(
                  "Step 5 of 6",
                  style: AppFontStyle.text_14_400(AppColors.grey),
                ),
              ),
              hBox(20),
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
                        maxLines: 3,
                        "Your documents are securely stored and used only for verification purposes.",
                        style: AppFontStyle.text_12_400(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              hBox(24),

              /// GOVERNMENT ID
              _documentTile(
                title: "Government ID",
                subtitle: "Driver's license or passport",
                required: true,
                uploaded: provider.isGovernmentUploaded,
                iconPath: ImageConstants.governmentId,
                onUpload: () => _pickFile(
                  context,
                  provider.setGovernmentId,
                ),
              ),
              hBox(16),

              /// CERTIFICATIONS
              _documentTile(
                title: "Certifications",
                subtitle: "Professional certificates (optional)",
                required: false,
                uploaded: provider.isCertificationUploaded,
                onUpload: () => _pickFile(
                  context,
                  provider.setCertification,
                ),
                iconPath: ImageConstants.certificate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- DOCUMENT TILE ----------------
  Widget _documentTile({
    required String title,
    required String subtitle,
    required bool required,
    required bool uploaded,
    required String iconPath,
    required VoidCallback onUpload,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: uploaded
            ? AppColors.white
            : AppColors.white,
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
                  border: Border.all(
                    color: AppColors.primary,
                  ),
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
            metric.extractPath(distance, end > metric.length ? metric.length : end),
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