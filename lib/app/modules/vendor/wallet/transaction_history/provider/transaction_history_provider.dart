import 'package:flutter/material.dart';

class TransactionModel {
  final String title;
  final String user;
  final String time;
  final double amount;
  final bool isCredit;

  TransactionModel({
    required this.title,
    required this.user,
    required this.time,
    required this.amount,
    required this.isCredit,
  });
}

class TransactionHistoryProvider extends ChangeNotifier {
  String selectedFilter = "All";

  final List<TransactionModel> transactions = [
    TransactionModel(
      title: "Deep Cleaning",
      user: "John Doe",
      time: "Today, 4:00 PM",
      amount: 120,
      isCredit: true,
    ),
    TransactionModel(
      title: "Deep Cleaning",
      user: "Mike Chen",
      time: "Yesterday, 6:30 PM",
      amount: 85,
      isCredit: true,
    ),
    TransactionModel(
      title: "Withdrawal",
      user: "Bank Transfer",
      time: "Dec 15, 6:30 PM",
      amount: 500,
      isCredit: false,
    ),
  ];

  void changeFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }
}
