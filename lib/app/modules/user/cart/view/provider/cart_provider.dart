import 'package:flutter/foundation.dart';
import '../../../../../data/repository/repository.dart';
import '../model/cart_items_model.dart';
import '../model/increase_cart_quantity_model.dart';

class CartProvider with ChangeNotifier {
  final Repository _repository;

  CartProvider({required Repository repository}) : _repository = repository;

  List<CartItem> _items = [];
  int _subtotal = 0;
  int _serviceFee = 0;
  int _total = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  int get subtotal => _subtotal;
  int get serviceFee => _serviceFee;
  int get total => _total;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCartItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final CartItemsModel response =
      await _repository.getCartItemsApi();

      if (response.status == true && response.data != null) {
        // ✅ Items
        _items = response.data!.items ?? [];

        // ✅ Summary
        final summary = response.data!.summary;
        _subtotal = summary?.subtotal ?? 0;
        _serviceFee = summary?.serviceFee ?? 0;
        _total = summary?.total ?? 0;
      } else {
        _items = [];
        _subtotal = 0;
        _serviceFee = 0;
        _total = 0;
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
      _errorMessage = e.toString();
      notifyListeners();

      print('Error fetching cart items: $e');
    }
  }

  Future<void> updateQuantity(int cartId, int delta) async {
    final index = _items.indexWhere((item) => item.cartId == cartId);
    if (index == -1) return;

    try {
      dynamic response;

      // 🔼 Increase API
      if (delta > 0) {
        response = await _repository.increaseCartItemApi(cartId);
      }
      // 🔽 Decrease API
      else {
        response = await _repository.decreaseCartItemApi(cartId);
      }

      print("Update Quantity Parsed Model: $response");

      // 🎯 Correct model access
      if (response.status == true && response.data != null) {

        final newQty = response.data!.quantity ?? 1;

        _items[index].quantity = newQty;

        final price = _items[index].servicePrice ?? 0;
        _items[index].serviceItemTotal = (price * newQty) as int?;

        // Recalculate totals
        _subtotal = _items.fold(
          0,
              (sum, item) => sum + (item.serviceItemTotal ?? 0),
        );
        _total = _subtotal + _serviceFee;

        notifyListeners();
      } else {
        throw Exception(response.message ?? "Failed to update quantity");
      }
    } catch (e) {
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
    _subtotal = _items.fold(0, (sum, item) => sum + (item.serviceItemTotal ?? 0));
    _total = _subtotal + _serviceFee;

    notifyListeners();

    try {
      final response = await _repository.removeCartItemApi(cartId);

      print('Remove Item Response: $response');

      // Check if API call was successful
      if (response != null && response['status'] == true) {
        // Item successfully removed, UI already updated
        print('Item removed successfully');
      } else {
        throw Exception(response?['message'] ?? 'Failed to remove item');
      }
    } catch (e) {
      // Revert on error
      _items.insert(index, removedItem);

      // Recalculate totals after reverting
      _subtotal = _items.fold(0, (sum, item) => sum + (item.serviceItemTotal ?? 0));
      _total = _subtotal + _serviceFee;

      _errorMessage = 'Failed to remove item: ${e.toString()}';
      notifyListeners();
      print('Error removing item: $e');
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}