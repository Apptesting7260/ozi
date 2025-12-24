
import '../appExports/app_export.dart';

OverlayEntry? _currentToastEntry;
OverlayEntry? _currentBarrierEntry;
bool _isToastVisible = false;

class _ToastOverlayEntry extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ToastOverlayEntry({
    required this.message,
    required this.onDismiss,
  });

  @override
  State<_ToastOverlayEntry> createState() => _ToastOverlayEntryState();
}

class _ToastOverlayEntryState extends State<_ToastOverlayEntry>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 14,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CustomImage(path: ImageConstants.appLogo,width: 32,height: 32,fit: BoxFit.contain,),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    maxLines: 4,
                    widget.message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomToast(
    BuildContext context,
    String message,
    ) {
  if (_isToastVisible) return;

  final overlay = Overlay.of(context);
  late OverlayEntry toastEntry;
  late OverlayEntry barrierEntry;
  barrierEntry = OverlayEntry(
    builder: (context) {
      return Positioned.fill(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
      );
    },
  );

  toastEntry = OverlayEntry(
    builder: (context) {
      return _ToastOverlayEntry(
        message: message,
        onDismiss: () {
          toastEntry.remove();
          barrierEntry.remove();
          _isToastVisible = false;
          _currentToastEntry = null;
          _currentBarrierEntry = null;
        },
      );
    },
  );

  _isToastVisible = true;
  _currentToastEntry = toastEntry;
  _currentBarrierEntry = barrierEntry;

  // Pehle barrier insert karo, phir toast
  overlay.insert(barrierEntry);
  overlay.insert(toastEntry);
}

void dismissToast() {
  _currentToastEntry?.remove();
  _currentBarrierEntry?.remove();
  _currentToastEntry = null;
  _currentBarrierEntry = null;
  _isToastVisible = false;
}

void successToast(BuildContext context, String msg) {
  showCustomToast(context, msg);
}

void errorToast(BuildContext context, String msg) {
  showCustomToast(context, msg);
}

class CustomConfirmationDialog {
  static Future<bool?> show(
      BuildContext context, {
        required String title,
        required String subtitle,
        required VoidCallback onYesPressed,
        String noText = 'No',
        String yesText = 'Yes',
        bool isDismissible = true,
      }) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: AppColors.transparent,
      builder: (context) => _buildDialog(
        context,
        title: title,
        subtitle: subtitle,
        onYesPressed: onYesPressed,
        noText: noText,
        yesText: yesText,
      ),
    );
  }

  static Widget _buildDialog(
      BuildContext context, {
        required String title,
        required String subtitle,
        required VoidCallback onYesPressed,
        required String noText,
        required String yesText,
      }) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppFontStyle.text_22_600(
              AppColors.darkText,
              fontFamily: AppFontFamily.semiBold,
            ),
          ),
          hBox(8),
          Text(
            subtitle,
            style: AppFontStyle.text_14_400(AppColors.grey),
            textAlign: TextAlign.center,
          ),
          hBox(20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  isOutlined: true,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  text: noText,
                ),
              ),
              wBox(12),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    onYesPressed();
                  },
                  text: yesText,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
