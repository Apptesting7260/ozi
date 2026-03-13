import '../../core/appExports/app_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? child;
  final Widget? columnChild;
  final double? height;
  final VoidCallback? onBackTap;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomAppBar({
    super.key,
    required this.title,
    this.child,
    this.columnChild,
    this.height,
    this.onBackTap,
    this.maxLines,
    this.overflow,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? 60.h);

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: topPadding + 4),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: onBackTap ?? () => Navigator.pop(context),
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
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: maxLines ?? 1,
                    overflow: overflow ?? TextOverflow.ellipsis,
                    style: AppFontStyle.text_18_600(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.bold,
                    ),
                  ),
                ),
                if (child != null)
                  Align(alignment: Alignment.centerRight, child: child!),

              ],
            ),
          ),
          if (columnChild != null)
            Padding(padding: REdgeInsets.only(top: 0.0), child: columnChild),
          hBox(10),
        ],
      ),
    );
  }
}
