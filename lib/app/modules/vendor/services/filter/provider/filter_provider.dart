import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  /// Sort
  bool active = true; // true = Active, false = Inactive

  /// Categories
  final List<String> allCategories = [
    "Tailor Services",
    "Entertainment & Event",
    "Towing Services",
    "Cleaning",
    "Handy Works",
    "Food",
    "Engineering",
    "Tutoring",
  ];

  final Set<String> selectedCategories = {};

  /// -------- ACTIONS --------

  void toggleSort(bool value) {
    active = value;
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    notifyListeners();
  }

  void clearAll() {
    active = true;
    selectedCategories.clear();
    notifyListeners();
  }

  bool get canApply => selectedCategories.isNotEmpty;
}
