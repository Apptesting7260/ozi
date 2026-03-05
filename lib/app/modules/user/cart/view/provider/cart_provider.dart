import 'package:flutter/foundation.dart';
import 'package:ozi/app/core/utils/get_utils.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../data/storage/user_preference.dart';
import '../model/cart_items_model.dart';

class CartProvider with ChangeNotifier {
  final Repository _repository;

  CartProvider({required Repository repository}) : _repository = repository;

  List<CartItem> _items = [];
  double _subtotal = 0;
  double _serviceFee = 0;
  double _discount = 0;
  double _total = 0;
  bool _isLoading = false;
  String? _errorMessage;
  String? _appliedCouponCode;
  String? _cupponCode;

  // Getters
  List<CartItem> get items => _items;
  int get itemCount =>
      _items.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  double get subtotal => _subtotal;
  double get serviceFee => _serviceFee;
  double get discount => _discount;
  double get total => _total;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get appliedCouponCode => _appliedCouponCode;

  Future<void> fetchCartItems() async {
    // 🔐 STEP 1: Check token first
    final token = await UserPreference.returnAccessToken();
    if (token == null || token.isEmpty) {
      // Guest user → do nothing
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final CartItemsModel response = await _repository.getCartItemsApi();

      if (response.status == true && response.data != null) {
        // Items
        _items = response.data!.items ?? [];

        //  Summary
        final summary = response.data!.summary;
        _subtotal = summary?.subtotal ?? 0.0;
        _serviceFee = summary?.serviceFee ?? 0.0;
        _discount = summary?.discount ?? 0.0;
        _total = summary?.total ?? 0.0;
        //  Applied Coupon from API
        _appliedCouponCode = summary?.appliedCuppon;
        _cupponCode = summary?.cupponId;
      } else {
        _items = [];
        _subtotal = 0;
        _serviceFee = 0;
        _total = 0;
        _appliedCouponCode = null;
        _errorMessage = response.message ?? 'Failed to load cart';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _items = [];
      _subtotal = 0;
      _serviceFee = 0;
      _total = 0;
      _appliedCouponCode = null;
      _errorMessage = e.toString();
      notifyListeners();
      Get.showToast(e.toString(), type: ToastType.error);
      if (kDebugMode) {
        print('Error fetching cart items: $e');
      }
    }
  }

  Future<void> updateQuantity(int cartId, int delta) async {
    final index = _items.indexWhere((item) => item.cartId == cartId);
    if (index == -1) return;

    try {
      dynamic response;

      //  Increase API
      if (delta > 0) {
        response = await _repository.increaseCartItemApi(cartId);
      }
      // 🔽 Decrease API
      else {
        response = await _repository.decreaseCartItemApi(cartId);
      }

      if (kDebugMode) {
        print("Update Quantity Parsed Model: $response");
      }

      //  Correct model access
      if (response.status == true && response.data != null) {
        final newQty = response.data!.quantity ?? 1;

        _items[index].quantity = newQty;

        final double price = _items[index].servicePrice ?? 0.0;
        _items[index].serviceItemTotal = price * newQty;

        // Recalculate totals
        _subtotal = _items.fold(
          0.0,
          (sum, item) => sum + (item.serviceItemTotal ?? 0.0),
        );
        _total = _subtotal + _serviceFee - _discount;

        notifyListeners();
      } else {
        throw Exception(response.message ?? "Failed to update quantity");
      }
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      _errorMessage = "Failed to update quantity: $e";
      notifyListeners();
    }
  }

  // Remove item from cart
  Future<void> removeItem(int cartId) async {
    final index = _items.indexWhere((item) => item.cartId == cartId);
    if (index == -1) return;

    // Store item for potential rollback
    final removedItem = _items[index];

    // Optimistically remove from UI
    _items.removeAt(index);

    // Recalculate totals optimistically
    _subtotal = _items.fold(
      0.0,
      (sum, item) => sum + (item.serviceItemTotal ?? 0.0),
    );
    _total = _subtotal + _serviceFee;

    notifyListeners();

    try {
      final response = await _repository.removeCartItemApi(cartId);

      if (kDebugMode) {
        print('Remove Item Response: $response');
      }

      // Check if API call was successful
      if (response != null && response['status'] == true) {
        // Item successfully removed, UI already updated
        if (kDebugMode) {
          print('Item removed successfully');
        }
      } else {
        throw Exception(response?['message'] ?? 'Failed to remove item');
      }
    } catch (e) {
      // Revert on error
      _items.insert(index, removedItem);

      // Recalculate totals after reverting
      _subtotal = _items.fold(
        0.0,
        (sum, item) => sum + (item.serviceItemTotal ?? 0.0),
      );
      _total = _subtotal + _serviceFee;

      _errorMessage = 'Failed to remove item: ${e.toString()}';
      notifyListeners();
      Get.showToast(e.toString(), type: ToastType.error);
      if (kDebugMode) {
        print('Error removing item: $e');
      }
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setAppliedCoupon(String? code) {
    _appliedCouponCode = code;
    notifyListeners();
  }

  bool _isRemoveLoading = false;
  bool get isRemoveLoading => _isRemoveLoading;
  set isRemoveLoading(bool value) {
    _isRemoveLoading = value;
    notifyListeners();
  }

  Future<void> removeCoupon() async {
    final String? codeToRemove = _cupponCode ?? _appliedCouponCode;
    if (kDebugMode) {
      print(
        'removeCoupon called, _cupponCode: $_cupponCode, _appliedCouponCode: $_appliedCouponCode',
      );
    }

    if (codeToRemove == null) {
      if (kDebugMode) {
        print('No coupon code or ID found to remove');
      }
      return;
    }

    _isRemoveLoading = true;
    notifyListeners();

    try {
      final response = await _repository.applyorRemoveCupponApi(codeToRemove);

      if (response != null && response['status'] == true) {
        _appliedCouponCode = null;
        _cupponCode = null;
        await fetchCartItems();
        Get.showToast("Coupon removed successfully", type: ToastType.success);
      } else {
        Get.showToast(
          response?['message'] ?? 'Failed to remove coupon',
          type: ToastType.error,
        );
      }
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
    } finally {
      _isRemoveLoading = false;
      notifyListeners();
    }
  }
}
