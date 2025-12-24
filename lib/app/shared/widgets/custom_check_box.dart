
import '../../core/appExports/app_export.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double? width;
  final double ?height;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: width ?? 20.w,
        height: height ?? 20.h,
        decoration: BoxDecoration(
          color: value
              ? AppColors.primary
              : AppColors.transparent,

          borderRadius: BorderRadius.circular(5.r),

          /// 🔥 border hidden when checked
          border: Border.all(
            color: value ? AppColors.transparent : AppColors.black,
            width: 1,
          ),
        ),
        child: value
            ? Icon(
          Icons.check,
          size: 14.sp,
          color: AppColors.white,
        )
            : null,
      ),
    );
  }
}
