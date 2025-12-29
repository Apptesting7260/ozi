import 'package:flutter/material.dart';

class HelpProvider extends ChangeNotifier {
  int _tabIndex = 0;
  int _expandedIndex = -1;

  int get tabIndex => _tabIndex;
  int get expandedIndex => _expandedIndex;

  void changeTab(int index) {
    _tabIndex = index;
    _expandedIndex = -1;
    notifyListeners();
  }

  void toggleExpanded(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = -1;
    } else {
      _expandedIndex = index; // Expand new item
    }
    notifyListeners();
  }
}