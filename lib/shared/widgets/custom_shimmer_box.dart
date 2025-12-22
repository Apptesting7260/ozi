import 'package:shimmer/shimmer.dart';
import '../../core/appExports/app_export.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius,
    this.isCircle,
  });

  final double width;
  final double height;
  final double? radius;
  final bool? isCircle;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey.withValues(alpha: 0.4),
      highlightColor: Colors.white.withValues(alpha: 0.2),
      child: Container(
        width: width,
        height: height,
        decoration: isCircle == true
            ? const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        )
            : BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 15.r),
        ),
      ),
    );
  }
}
