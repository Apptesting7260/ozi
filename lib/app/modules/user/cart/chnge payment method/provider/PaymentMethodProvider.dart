import 'package:flutter/material.dart';

import '../../../../../core/constants/image_constant.dart';


class PaymentModel {
  final String title;
  final String masked;
  final String? label;
  final String icon;

  PaymentModel({
    required this.title,
    required this.masked,
    required this.icon,
    this.label,
  });
}

class PaymentMethodProvider extends ChangeNotifier {
  int selectedIndex = 0;

  List<PaymentModel> list = [
    PaymentModel(
      title: "Visa",
      masked: "•••• 4242",
      icon: ImageConstants.card,
      label: "Default",
    ),
    PaymentModel(
      title: "Mastercard",
      masked: "•••• 8888",
      icon: ImageConstants.card,
    ),
    PaymentModel(
      title: "Cash",
      masked: "",
      icon: ImageConstants.cash,
    ),
  ];

  void selectCard(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
