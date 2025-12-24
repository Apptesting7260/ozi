
import '../../core/appExports/app_export.dart';
import '../../core/utils/get_utils.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.maxLength,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.readOnly,
    this.enabled,
    this.onChanged,
    this.onTapOutside,
    this.borderRadius,
    this.inputFormatters,
    this.minLines,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.labelText,
    this.autoValidateMode, this.buildCounter, this.label,
  });

  final Alignment? alignment;
  final bool ?readOnly;
  final double? width;
  final double? height;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final int? minLines;

  final int? maxLength;

  final String? hintText;
  final String? label;

  final TextStyle? hintStyle;

  // final TextStyle? errorTextStyle;

  // final Color? errorTextClr;

  final Widget? prefix;
  final InputCounterWidgetBuilder? buildCounter;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final double? borderRadius;

  final VoidCallback? onTap;

  final FormFieldValidator<String>? validator;

  final bool? enabled;

  final Function(String value)? onChanged;

  final TapRegionCallback? onTapOutside;

  final List<TextInputFormatter>? inputFormatters;

  final Function()? onEditingComplete;

  final Function(String)? onFieldSubmitted;

  final String? labelText;
  final AutovalidateMode? autoValidateMode;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: textFormFieldWidget,
    )
        : textFormFieldWidget;
  }

  Widget get textFormFieldWidget => SizedBox(
    width: width ?? double.maxFinite,
    height: height,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label!=null)
        Padding(
          padding:  EdgeInsets.only(bottom: 4.h),
          child: Text(label??"",style: AppFontStyle.text_16_500(AppColors.darkText, fontFamily: AppFontFamily.medium),),
        ),
        TextFormField(
          readOnly: readOnly??false,
          buildCounter: buildCounter,
          // expands: true,
          onTap: onTap,
          maxLength: maxLength,
          onTapOutside:onTapOutside ?? (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: onChanged,
          autovalidateMode: autoValidateMode ?? AutovalidateMode.onUserInteraction,
          enabled: enabled ?? true,
          controller: controller,
          autofocus: autofocus ?? false,
          style: textStyle ?? AppFontStyle.text_14_400(AppColors.darkText,),
          obscureText: obscureText!,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          minLines: minLines ?? 1,
          decoration: decoration,
          validator: validator,
          inputFormatters: inputFormatters,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          cursorColor: AppColors.black,
        ),
      ],
    ),
  );

  InputDecoration get decoration => InputDecoration(
    errorStyle:  Get.errorTextStyle(),
    alignLabelWithHint: true,
    labelText: labelText,
    errorMaxLines: 10,
    hintText: hintText ?? "",
    hintStyle: hintStyle ??
        AppFontStyle.text_14_400(
          AppColors.hintText,
        ),
    labelStyle: hintStyle ??
        AppFontStyle.text_14_500(
          AppColors.hintText,
        ),
    prefixIcon: prefix,
    prefixIconConstraints: prefixConstraints ?? BoxConstraints(minWidth: 30.w),
    suffixIcon: suffix,
    suffixIconConstraints: suffixConstraints,
    isDense: true,
    contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    fillColor: fillColor ?? AppColors.fieldBgColor,
    filled: filled,
    border: borderDecoration ?? Get.defaultBorder(borderRadius),
    enabledBorder: borderDecoration ?? Get.defaultBorder(borderRadius),
    focusedBorder: borderDecoration ?? Get.focusedBorder(borderRadius),
    disabledBorder: borderDecoration ?? Get.defaultBorder(borderRadius),
    errorBorder: Get.errorBorder(borderRadius),
    focusedErrorBorder: Get.errorBorder(borderRadius),

  );
}
