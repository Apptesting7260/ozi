import 'package:flutter/material.dart';

class AddressModel {
  final String title;
  final String address;
  final String? label;

  AddressModel({
    required this.title,
    required this.address,
    this.label,
  });
}

class ChangeAddressProvider extends ChangeNotifier {
  int selectedIndex = 0;

  List<AddressModel> addresses = [
    AddressModel(
      title: "Home",
      address: "123 Main Street, San Francisco, CA 94102",
      label: "Default",
    ),
    AddressModel(
      title: "Work",
      address: "123 Main Street, San Francisco, CA 94102",
    ),
    AddressModel(
      title: "Other",
      address: "123 Market Street, Apt 4B\nSan Francisco, CA 94102",
    ),
  ];

  void selectCard(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
