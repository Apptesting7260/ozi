import 'dart:async';
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  Timer? _timer;

  void startTimer(BuildContext context, VoidCallback onComplete) {
    _timer = Timer(const Duration(seconds: 2), () {
      onComplete();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}