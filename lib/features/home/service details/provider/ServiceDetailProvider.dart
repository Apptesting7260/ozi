// service_detail_provider.dart
import 'package:flutter/material.dart';

import '../../services/provider/CategoryDetailProvider.dart';

// Model for Service Provider
class ServiceProvider {
  final String id;
  final String title;
  final String description;
  final double price;
  final String duration;
  final String imagePath;

  ServiceProvider({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.imagePath,
  });
}

class ServiceDetailProvider extends ChangeNotifier {
  final Service service;

  ServiceDetailProvider(this.service);

  // Cart items: serviceId -> quantity
  final Map<String, int> _cartItems = {};

  // Sample service providers data
  List<ServiceProvider> get serviceProviders {
    // You can customize this based on the service category
    return [
      ServiceProvider(
        id: '1',
        title: 'Shirt Sleeve Shortening & Fitting Service',
        description:
        'High-pressure full body massage to target pain points, knots & muscle soreness. Treats deeper muscle layers, heals sports injuries & improves flexibility',
        price: 84.13,
        duration: '2 Hours',
        imagePath: 'https://images.unsplash.com/photo-1581235720704-06d3acfcb36f',
      ),
      ServiceProvider(
        id: '2',
        title: 'Shirt Sleeve Shortening & Fitting Service',
        description:
        'High-pressure full body massage to target pain points, knots & muscle soreness. Treats deeper muscle layers, heals sports injuries & improves flexibility',
        price: 84.13,
        duration: '2 Hours',
        imagePath: 'https://images.unsplash.com/photo-1581235720704-06d3acfcb36f',
      ),
      ServiceProvider(
        id: '3',
        title: 'Professional Alteration Service',
        description:
        'Expert tailoring service for perfect fit. Includes measurements, fitting adjustments and quality stitching',
        price: 95.50,
        duration: '3 Hours',
        imagePath: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2',
      ),
      ServiceProvider(
        id: '4',
        title: 'Custom Suit Tailoring',
        description:
        'Premium suit tailoring with custom measurements and premium fabric selection',
        price: 150.00,
        duration: '4 Hours',
        imagePath: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35',
      ),
    ];
  }

  bool isInCart(String serviceId) {
    return _cartItems.containsKey(serviceId) && _cartItems[serviceId]! > 0;
  }

  int getQuantity(String serviceId) {
    return _cartItems[serviceId] ?? 0;
  }

  void addToCart(String serviceId) {
    _cartItems[serviceId] = 1;
    notifyListeners();
  }

  void incrementQuantity(String serviceId) {
    if (_cartItems.containsKey(serviceId)) {
      _cartItems[serviceId] = _cartItems[serviceId]! + 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String serviceId) {
    if (_cartItems.containsKey(serviceId)) {
      if (_cartItems[serviceId]! > 1) {
        _cartItems[serviceId] = _cartItems[serviceId]! - 1;
      } else {
        _cartItems.remove(serviceId);
      }
      notifyListeners();
    }
  }

  double get totalAmount {
    double total = 0;
    _cartItems.forEach((serviceId, quantity) {
      final serviceProvider = serviceProviders.firstWhere(
            (sp) => sp.id == serviceId,
        orElse: () => serviceProviders.first,
      );
      total += serviceProvider.price * quantity;
    });
    return total;
  }

  int get cartItemCount {
    int count = 0;
    _cartItems.forEach((_, quantity) {
      count += quantity;
    });
    return count;
  }

  void onViewCartTap(BuildContext context) {
    // Navigate to cart screen
    print("View Cart tapped - Total: \$${totalAmount.toStringAsFixed(2)}");
    // Navigator.pushNamed(context, '/cart');
  }
}