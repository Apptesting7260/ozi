import 'package:flutter/material.dart';

import '../../../../data/repository/repository.dart';
import '../model/wallet_detail_model.dart';

class WalletProvider extends ChangeNotifier {
  final Repository _repo = Repository();

  bool _isLoading = false;
  String? _error;
  WalletDetailModel? _walletModel;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  double get availableBalance =>
      double.tryParse(_walletModel?.data?.availableBalance ?? "0") ?? 0;

  double get todayEarning =>
      double.tryParse(_walletModel?.data?.todayEarning ?? "0") ?? 0;

  double get weeklyEarning =>
      double.tryParse(_walletModel?.data?.weekEarning ?? "0") ?? 0;


  List<RecentTransactions> get transactions =>
      _walletModel?.data?.recentTransactions ?? [];

  Future<void> fetchWalletDetail({bool refresh = false}) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repo.fetchWalletDetail();
      _walletModel = response;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
