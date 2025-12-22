import 'package:flutter/foundation.dart';


class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      name: 'Shirt Sleeve Shortening & Fitting Service',
      price: 84.13,
      imageUrl: 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=200&h=200&fit=crop',
    ),
    CartItem(
      id: '2',
      name: 'Shirt Sleeve Shortening & Fitting Service',
      price: 84.13,
      imageUrl: 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=200&h=200&fit=crop',
    ),
  ];

  final double _serviceFee = 5.00;

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  double get serviceFee => _serviceFee;

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get total => subtotal + serviceFee;

  void updateQuantity(String id, int delta) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].quantity = (_items[index].quantity + delta).clamp(1, 99);
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}