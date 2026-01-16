import 'package:flutter/foundation.dart';
import '../../../../../data/repository/repository.dart';
import '../model/cart_items_model.dart';

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

  // Fetch cart items from API
  Future<void> fetchCartItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getCartItemsApi();
      print('Cart Response: $response');

      if (response != null && response['status'] == true) {
        final data = response['data'];

        // Parse items
        if (data['items'] != null) {
          _items = (data['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList();
        } else {
          _items = [];
        }

        // Parse summary
        if (data['summary'] != null) {
          final summary = data['summary'];
          _subtotal = summary['subtotal'] ?? 0;
          _serviceFee = summary['service_fee'] ?? 0;
          _total = summary['total'] ?? 0;
        } else {
          _subtotal = 0;
          _serviceFee = 0;
          _total = 0;
        }

        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception(response?['message'] ?? 'Failed to load cart items');
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _items = [];
      _subtotal = 0;
      _serviceFee = 0;
      _total = 0;
      notifyListeners();
      print('Error fetching cart items: $e');
    }
  }

  // Update quantity - increase or decrease
  Future<void> updateQuantity(int cartId, int delta) async {
    final index = _items.indexWhere((item) => item.cartId == cartId);
    if (index == -1) return;

    final _ = _items[index].quantity ?? 1;

    try {
      dynamic response;

      // Call appropriate API based on delta
      if (delta > 0) {
        // Increase quantity
        response = await _repository.increaseCartItemApi(cartId);
      } else if (delta < 0) {
        // Decrease quantity
        response = await _repository.decreaseCartItemApi(cartId);
      }

      print('Update Quantity Response: $response');

      // Check if API call was successful
      if (response != null && response['status'] == true) {
        // Update quantity from API response
        if (response['data'] != null) {
          final newQuantity = response['data']['quantity'] as int;
          _items[index].quantity = newQuantity;

          // Update item total
          final itemPrice = _items[index].servicePrice ?? 0;
          _items[index].serviceItemTotal = (itemPrice * newQuantity).toInt();

          // Recalculate totals
          _subtotal = _items.fold(0, (sum, item) => sum + (item.serviceItemTotal ?? 0));
          _total = _subtotal + _serviceFee;

          notifyListeners();
        }
      } else {
        throw Exception(response?['message'] ?? 'Failed to update quantity');
      }
    } catch (e) {
      _errorMessage = 'Failed to update quantity: ${e.toString()}';
      notifyListeners();
      print('Error updating quantity: $e');
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