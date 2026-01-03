import '../../../../core/appExports/app_export.dart';

class VerificationProvider extends ChangeNotifier {
  final TextEditingController otpController = TextEditingController();

  int resendTime = 55;
  Timer? timer;

  void startTimer() {
    timer?.cancel(); // safety
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTime > 0) {
        resendTime--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }
}
