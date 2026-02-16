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

  PaymentMethodProvider({String? initialTitle}) {
    if (initialTitle != null) {
      final index = list.indexWhere((element) => element.title == initialTitle);
      if (index != -1) {
        selectedIndex = index;
      }
    }
  }

  List<PaymentModel> list = [
    PaymentModel(
      title: "Cash",
      masked: "",
      icon: ImageConstants.cash,
      label: "Default",
    ),
    PaymentModel(title: " Pay Online", masked: "", icon: ImageConstants.card),
  ];

  void selectCard(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
