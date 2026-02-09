import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/core/utils/get_utils.dart';
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
      _couponsModel = await _repository.getgetCouponsApi();
      if (_appliedCouponCode != null && _couponsModel?.data != null) {
        _selectedCoupon = _couponsModel!.data!.firstWhere(
          (coupon) => coupon.code == _appliedCouponCode,
          orElse: () => Data(),
        );
        if (_selectedCoupon?.id == null) _selectedCoupon = null;
      }
    } catch (e) {
      Get.showToast(
        e.toString() ?? 'Something went wrong',
        type: ToastType.error,
      );
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCoupon(Data? coupon) {
    if (_selectedCoupon?.id == coupon?.id) {
      _selectedCoupon = null;
      _appliedCouponCode = null;
    } else {
      _selectedCoupon = coupon;
      _appliedCouponCode = coupon?.code;
    }
    notifyListeners();
  }

  void setAppliedCouponCode(String? code) {
    _appliedCouponCode = code;
    if (_couponsModel?.data != null && code != null) {
      _selectedCoupon = _couponsModel!.data!.firstWhere(
        (coupon) => coupon.code == code,
        orElse: () => Data(),
      );
      if (_selectedCoupon?.id == null) _selectedCoupon = null;
    }
    notifyListeners();
  }

  bool _isApplyLoading = false;
  bool get isApplyLoading => _isApplyLoading;

  Future<bool> applyCoupon(String promoId) async {
    _isApplyLoading = true;
    notifyListeners();

    try {
      final response = await _repository.applyorRemoveCupponApi(promoId);

      if (response != null && response['status'] == true) {
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
        e.toString() ?? 'Something went wrong',
        type: ToastType.error,
      );
      return false;
    } finally {
      _isApplyLoading = false;
      notifyListeners();
    }
  }
}
