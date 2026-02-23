import 'package:flutter/material.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/modules/user/singleService/model/singleservicemodel.dart';
import 'package:ozi/app/modules/user/cart/view/model/cart_items_model.dart';
import 'package:ozi/app/core/utils/get_utils.dart';

import '../../../../data/storage/user_preference.dart';

class SingleServiceProvider extends ChangeNotifier {
  final Repository _repository;
  SingleServiceProvider(this._repository);

  singleServiceModel? _serviceData;
  singleServiceModel? get serviceData => _serviceData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Map<int, int> _cartQuantities = {};
  List<CartItem> _cartItems = [];
  int _totalAmount = 0;
  int get totalAmount => _totalAmount;
  int _cartItemCount = 0;
  int get cartItemCount => _cartItemCount;

  Future<void> getSingleService(int serviceId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.getSingleServiceApi(serviceId);
      if (response != null) {
        _serviceData = singleServiceModel.fromJson(response);
        await fetchCartItems();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCartItems() async {
    // 🔐 STEP 1: Check token first
    final token = await UserPreference.returnAccessToken();
    if (token == null || token.isEmpty) {
      // Guest user → do nothing
      return;
    }

    try {
      final response = await _repository.getCartItemsApi();
      if (response.status == true && response.data != null) {
        _cartItems = response.data!.items ?? [];
        _totalAmount = response.data!.summary?.total ?? 0;
        _cartItemCount = response.data!.summary?.itemsCount ?? 0;
        _cartQuantities.clear();
        for (var item in _cartItems) {
          if (item.serviceId != null && item.quantity != null) {
            final svcId = int.tryParse(item.serviceId!);
            if (svcId != null) {
              _cartQuantities[svcId] = item.quantity!;
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  bool isInCart(int serviceId) {
    return _cartQuantities.containsKey(serviceId) &&
        (_cartQuantities[serviceId] ?? 0) > 0;
  }

  int getQuantity(int serviceId) {
    return _cartQuantities[serviceId] ?? 0;
  }

  Future<void> addToCart(int serviceId) async {
    try {
      final response = await _repository.addToCartApi({
        'service_id': serviceId,
        'quantity': 1,
      });

      if (response.status == true) {
        await fetchCartItems();
        Get.showToast(
          response.message ?? 'Added to cart',
          type: ToastType.success,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> incrementQuantity(int serviceId) async {
    final item = _cartItems.firstWhere(
      (element) => element.serviceId == serviceId.toString(),
      orElse: () => CartItem(),
    );

    if (item.cartId != null) {
      final response = await _repository.increaseCartItemApi(item.cartId!);
      if (response.status == true) {
        await fetchCartItems();
      }
    } else {
      await addToCart(serviceId);
    }
  }

  Future<void> decrementQuantity(int serviceId) async {
    final item = _cartItems.firstWhere(
      (element) => element.serviceId == serviceId.toString(),
      orElse: () => CartItem(),
    );

    if (item.cartId != null) {
      if ((item.quantity ?? 0) > 1) {
        final response = await _repository.decreaseCartItemApi(item.cartId!);
        if (response.status == true) {
          await fetchCartItems();
        }
      } else {
        final response = await _repository.removeCartItemApi(item.cartId!);
        if (response != null && response['status'] == true) {
          await fetchCartItems();
        }
      }
    }
  }
}
