import '../../core/appExports/app_export.dart';

class CustomRadioButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.transparent,
          border: Border.all(
            color: value ? AppColors.primary : AppColors.radioButton,
            width: 1.5,
          ),
        ),
        child: value
            ? Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
          ),
        )
            : null,
      ),
    );
  }
}
