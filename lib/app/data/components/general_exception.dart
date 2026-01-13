import '../../core/appExports/app_export.dart';

class GeneralExceptionWidget extends StatefulWidget {
  final VoidCallback onPress;
  final String? title;
  final String? message;
  final IconData? icon;

  const GeneralExceptionWidget({
    super.key,
    required this.onPress,
    this.title,
    this.message,
    this.icon,
  });

  @override
  State<GeneralExceptionWidget> createState() => _GeneralExceptionWidgetState();
}

class _GeneralExceptionWidgetState extends State<GeneralExceptionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child:      Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(path: ImageConstants.error,color: AppColors.primary,),
              hBox(14),
              Text(
                widget.title ?? 'Something went wrong',
                style: AppFontStyle.text_18_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
              hBox(8),
              Text(
                maxLines: 2,
                widget.message ?? 'Please try again',
                textAlign: TextAlign.center,
                style: AppFontStyle.text_14_400(AppColors.grey),
              ),
              hBox(20),
              CustomButton(
                width: 180,
                onPressed: widget.onPress,
                text: 'Try Again',
              ),
            ],
          ),
        ),
      )
    );
  }
}


