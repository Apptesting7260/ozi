import 'package:flutter/material.dart';
import 'dart:io';

class ServiceDetailsProvider extends ChangeNotifier {
  File? pickedImage;

  String? category;
  String? subCategory;
  String? durationUnit;
  String? durationValue;
  String? serviceName;
  String? description;
  String? priceAmount;

  void setImage(File file) {
    pickedImage = file;
    notifyListeners();
  }

  void setCategory(String? val) {
    category = val;
    notifyListeners();
  }

  void setSubCategory(String? val) {
    subCategory = val;
    notifyListeners();
  }

  void setDurationUnit(String? val) {
    durationUnit = val;
    notifyListeners();
  }

  void setDurationValue(String? val) {
    durationValue = val;
    notifyListeners();
  }

  void setPrice(String? val) {
    priceAmount = val;
    notifyListeners();
  }

  void setName(String? val) {
    serviceName = val;
    notifyListeners();
  }

  void setDescription(String? val) {
    description = val;
    notifyListeners();
  }

  bool get enableContinue =>
      pickedImage != null &&
          serviceName != null &&
          category != null &&
          priceAmount != null;
}
