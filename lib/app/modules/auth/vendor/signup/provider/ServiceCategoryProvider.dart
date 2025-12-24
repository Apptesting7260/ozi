import 'package:flutter/material.dart';

class ServiceCategoryProvider extends ChangeNotifier {
  final List<String> _selected = [];

  List<String> get selected => _selected;

  void toggleCategory(String category) {
    if (_selected.contains(category)) {
      _selected.remove(category);
    } else {
      _selected.add(category);
    }
    notifyListeners();
  }

  bool isSelected(String category) => _selected.contains(category);
}
