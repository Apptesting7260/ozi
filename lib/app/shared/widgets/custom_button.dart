import '../../core/appExports/app_export.dart';

class CustomButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? forGroundColor;
  final VoidCallback? onPressed;
  final Widget? child;
  final bool? isLoading;
  final String text;
  final TextStyle? textStyle;
  final bool isOutlined;

  const CustomButton({
    super.key,
    this.borderRadius,
    this.width,
    this.height,
    this.color,
    this.gradient,
    this.borderColor,
    this.forGroundColor,
    required this.onPressed,
    this.child,
    this.isLoading,
    this.text = "",
    this.textStyle,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null && isLoading != true;
    final Color effectiveColor = isDisabled
        ? (color?.withOpacity(0.3) ?? AppColors.primaryLight)
        : (color ?? AppColors.primary);
    final Color effectiveBorderColor = isDisabled
        ? (borderColor?.withOpacity(0.1) ?? AppColors.primaryLight)
        : (borderColor ?? color ?? AppColors.primary);
    final Color effectiveTextColor = isDisabled
        ? AppColors.white
        : (forGroundColor ??
              (isOutlined
                  ? AppColors.primary
                  : (AppColors.containerBorder)));

    return GestureDetector(
      onTap: isLoading == true ? null : onPressed,
      child: Container(
        width: width ?? MediaQuery.sizeOf(context).width,
        height: height ?? 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : effectiveColor,
          gradient: isOutlined || isDisabled
              ? null
              : LinearGradient(colors: [effectiveColor, effectiveColor]),
          borderRadius: borderRadius ?? BorderRadius.circular(60.0.r),
          border: Border.all(
            color: isOutlined
                ? (borderColor ?? AppColors.primary)
                : effectiveBorderColor,
            width: 1,
          ),
        ),
        child:
            child ??
            (isLoading == true
                ? LoadingAnimationWidget.threeArchedCircle(
                    color: forGroundColor ?? AppColors.white,
                    size: 30,
                  )
                : Text(
                    text,
                    style:
                        textStyle ??
                        AppFontStyle.text_14_600(
                          effectiveTextColor,
                          fontFamily: AppFontFamily.semiBold,
                        ),
                    textAlign: TextAlign.center,
                  )),
      ),
    );
  }
}
