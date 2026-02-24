import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/modules/user/cart/view/model/couponmodel.dart';

class CupponProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  getCupponsModel? _couponsModel;
  bool _isLoading = false;
  String? _errorMessage;
  Data? _selectedCoupon;
  String? _appliedCouponCode;

  // Getters
  getCupponsModel? get couponsModel => _couponsModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Data? get selectedCoupon => _selectedCoupon;
  String? get appliedCouponCode => _appliedCouponCode;

  Future<void> fetchCoupons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _couponsModel = await _repository.getCouponsApi();
      // Removed automatic selection logic
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
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

  void setAppliedCouponCode(String? code) {
    _appliedCouponCode = code;
    notifyListeners();
  }

  void clearSelection() {
    _selectedCoupon = null;
    notifyListeners();
  }

  bool _isApplyLoading = false;
  bool get isApplyLoading => _isApplyLoading;

  Future<bool> applyCoupon(String promoId, {String? code}) async {
    _isApplyLoading = true;
    notifyListeners();

    try {
      final response = await _repository.applyorRemoveCupponApi(promoId);

      if (response != null && response['status'] == true) {
        _appliedCouponCode = code ?? _selectedCoupon?.code;
        Get.showToast(
          response['message'] ?? "Coupon applied successfully",
          type: ToastType.success,
        );
        return true;
      } else {
        Get.showToast(
          response?['message'] ?? "Failed to apply coupon",
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      Get.showToast(
        e.toString(),
        type: ToastType.error,
      );
      return false;
    } finally {
      _isApplyLoading = false;
      notifyListeners();
    }
  }
}
