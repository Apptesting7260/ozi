import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/modules/user/singleService/model/singleservicemodel.dart';
import 'package:ozi/app/modules/user/cart/view/model/cart_items_model.dart';
import '../../../../core/appExports/app_export.dart';
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

  final Map<int, int> _cartQuantities = {};
  List<CartItem> _cartItems = [];
  double _totalAmount = 0;
  double get totalAmount => _totalAmount;
  double _subtotalAmount = 0;
  double get subtotalAmount => _subtotalAmount;
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
      Get.showToast(e.toString(), type: ToastType.error);
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
        _totalAmount = response.data!.summary?.total ?? 0.0;
        _subtotalAmount = response.data!.summary?.subtotal ?? 0.0;
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
      if (kDebugMode) {
        print('Error fetching cart items: $e');
      }
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
      await updateQuantity(item.cartId!, 1);
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
        await updateQuantity(item.cartId!, -1);
      } else {
        await removeItem(item.cartId!);
      }
    }
  }

  Future<void> updateQuantity(int cartId, int delta) async {
    final index = _cartItems.indexWhere((item) => item.cartId == cartId);
    if (index == -1) return;

    // Store state for rollback
    final originalQty = _cartItems[index].quantity ?? 0;
    final double price = _cartItems[index].servicePrice ?? 0.0;
    final originalItemTotal = _cartItems[index].serviceItemTotal ?? 0.0;
    final originalTotal = _totalAmount;

    final newQty = originalQty + delta;
    if (newQty < 1) return;

    // Optimistic update
    _cartItems[index].quantity = newQty;
    _cartItems[index].serviceItemTotal = price * newQty;

    // Sync _cartQuantities map
    int? svcId;
    if (_cartItems[index].serviceId != null) {
      svcId = int.tryParse(_cartItems[index].serviceId!);
      if (svcId != null) {
        _cartQuantities[svcId] = newQty;
      }
    }

    // Recalculate amounts
    _subtotalAmount = _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.serviceItemTotal ?? 0.0),
    );
    // Note: totalAmount is usually fetched from API or calculated with fees
    // For now we sync optimistic total with subtotal if we don't know fees
    _totalAmount = _subtotalAmount;

    notifyListeners();

    try {
      dynamic response;
      if (delta > 0) {
        response = await _repository.increaseCartItemApi(cartId);
      } else {
        response = await _repository.decreaseCartItemApi(cartId);
      }

      if (response.status == true) {
        // Sync with server response
        await fetchCartItems();
      } else {
        throw Exception(response.message ?? "Failed to update quantity");
      }
    } catch (e) {
      // Revert on error
      _cartItems[index].quantity = originalQty;
      _cartItems[index].serviceItemTotal = originalItemTotal;
      if (svcId != null) {
        _cartQuantities[svcId] = originalQty;
      }
      _totalAmount = originalTotal;
      notifyListeners();
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }

  Future<void> removeItem(int cartId) async {
    final index = _cartItems.indexWhere((item) => item.cartId == cartId);
    if (index == -1) return;

    final removedItem = _cartItems[index];
    final originalTotal = _totalAmount;

    // Optimistically remove
    _cartItems.removeAt(index);
    if (removedItem.serviceId != null) {
      final svcId = int.tryParse(removedItem.serviceId!);
      if (svcId != null) {
        _cartQuantities.remove(svcId);
      }
    }

    _subtotalAmount = _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.serviceItemTotal ?? 0.0),
    );
    _totalAmount = _subtotalAmount;
    _cartItemCount = _cartItems.length;

    notifyListeners();

    try {
      final response = await _repository.removeCartItemApi(cartId);
      if (response != null && response['status'] == true) {
        await fetchCartItems();
      } else {
        throw Exception(response?['message'] ?? 'Failed to remove item');
      }
    } catch (e) {
      // Revert
      _cartItems.insert(index, removedItem);
      if (removedItem.serviceId != null) {
        final svcId = int.tryParse(removedItem.serviceId!);
        if (svcId != null) {
          _cartQuantities[svcId] = removedItem.quantity ?? 0;
        }
      }
      _totalAmount = originalTotal;
      _cartItemCount = _cartItems.length;
      notifyListeners();
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }
}
