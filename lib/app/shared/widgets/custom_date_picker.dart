
import '../../core/appExports/app_export.dart';

class CustomDatePicker {
  /// Show date picker for age verification (18+ years old)
  static Future<DateTime?> show(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime maxSelectableDate = DateTime(today.year - 18, today.month, today.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: maxSelectableDate,
      firstDate: DateTime(1900),
      lastDate: maxSelectableDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return pickedDate;
  }

  static Future<DateTime?> showServiceDatePicker(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime maxSelectableDate = DateTime(today.year + 1, today.month, today.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: maxSelectableDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return pickedDate;
  }
}