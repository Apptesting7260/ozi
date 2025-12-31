import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  /// Sort
  /// null = none selected
  /// true = Active
  /// false = Inactive
  bool? active;

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

  /// Used by UI (alias)
  void selectStatus(bool value) {
    active = value;
    notifyListeners();
  }

  /// Toggle category selection
  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    notifyListeners();
  }

  /// Clear all filters
  void clearAll() {
    active = null;
    selectedCategories.clear();
    notifyListeners();
  }

  /// Enable Apply Filters button
  bool get canApply =>
      active != null || selectedCategories.isNotEmpty;
}
