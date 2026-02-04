import 'package:flutter/material.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/modules/user/cart/view/model/couponmodel.dart';

class CupponProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  getCupponsModel? _couponsModel;
  bool _isLoading = false;
  String? _errorMessage;
  Data? _selectedCoupon;

  // Getters
  getCupponsModel? get couponsModel => _couponsModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Data? get selectedCoupon => _selectedCoupon;

  Future<void> fetchCoupons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _couponsModel = await _repository.getgetCouponsApi();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCoupon(Data? coupon) {
    if (_selectedCoupon?.id == coupon?.id) {
      _selectedCoupon = null;
    } else {
      _selectedCoupon = coupon;
    }
    notifyListeners();
  }
}
