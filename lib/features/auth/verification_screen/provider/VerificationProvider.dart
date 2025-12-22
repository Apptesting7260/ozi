import 'dart:async';
import 'package:flutter/material.dart';

class VerificationProvider extends ChangeNotifier {
  TextEditingController otpController = TextEditingController();

  int resendTime = 55;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTime > 0) {
        resendTime--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void disposeProvider() {
    timer?.cancel();
    otpController.dispose();
  }
}
