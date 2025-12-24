import 'package:flutter/material.dart';

class AddressTypeProvider extends ChangeNotifier {

  int _selectedType = 0;
  int get selectedType => _selectedType;

  void updateType(int index) {
    _selectedType = index;
    notifyListeners();
  }
}
