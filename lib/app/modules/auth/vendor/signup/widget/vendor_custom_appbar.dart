import '../../../../../core/appExports/app_export.dart';

class VendorCustomAppBar extends StatelessWidget {
  final String title;
  final Widget? child;        // right side widget
  final Widget? columnChild;  // subtitle / extra content

  const VendorCustomAppBar({
    super.key,
    required this.title,
    this.child,
    this.columnChild,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: topPadding + 8,
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// -------- Back Button (LEFT) --------
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEFEFEF),
              ),
              padding: REdgeInsets.all(14),
              child: CustomImage(path: ImageConstants.back),
            ),
          ),

          /// -------- CENTER TITLE --------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppFontStyle.text_18_600(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.bold,
                  ),
                ),
                if (columnChild != null) columnChild!,
              ],
            ),
          ),

          /// -------- RIGHT PLACEHOLDER / ACTION --------
          SizedBox(
            width: 40, // same width as back button
            height: 40,
            child: child, // if null → keeps spacing
          ),
        ],
      ),
    );
  }
}
