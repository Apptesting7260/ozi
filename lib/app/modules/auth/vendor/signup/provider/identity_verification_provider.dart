import 'dart:io';
import 'package:flutter/material.dart';

class IdentityVerificationProvider extends ChangeNotifier {
  File? governmentId;
  File? certification;

  bool get isGovernmentUploaded => governmentId != null;
  bool get isCertificationUploaded => certification != null;

  bool get canContinue => isGovernmentUploaded;

  void setGovernmentId(File file) {
    governmentId = file;
    notifyListeners();
  }

  void setCertification(File file) {
    certification = file;
    notifyListeners();
  }
}
