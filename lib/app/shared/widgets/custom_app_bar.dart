

import '../../core/appExports/app_export.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? child;
  final Widget? columnChild;

  const CustomAppBar({
    super.key,
    required this.title,
    this.child,
    this.columnChild,
  });

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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEFEFEF),
                      ),
                      padding: REdgeInsets.all(14),
                      child: CustomImage(path: ImageConstants.back),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    title,
                    style: AppFontStyle.text_18_600(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.bold,
                    ),
                  ),
                ),
                if (child != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: child!,
                  ),
              ],
            ),
          ),
          if (columnChild != null)
            Padding(
              padding: REdgeInsets.only(top: 0.0),
              child: columnChild,
            ),
          hBox(10),
        ],
      ),
    );
  }
}
