import '../../core/appExports/app_export.dart';

class CustomBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    Widget? rowContent,
    Color? backgroundColor,
    double borderRadius = 20,
  }) {
    return showModalBottomSheet<T>(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      backgroundColor:AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: rowContent != null ? 20 : 0,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: REdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? AppColors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(borderRadius),
                      ),
                    ),
                    child: content,
                  ),
                ),
              ),

              Positioned(
                top: 15,
                right: 15,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: AppColors.darkText,
                      size: 22.sp,
                    ),
                  ),
                ),
              ),

              // Fixed bottom rowContent
              if (rowContent != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: rowContent,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

}