import 'package:flutter/material.dart';

class MyServiceModel {
  final String id;
  final String title;
  final String category;
  final String duration;
  final double price;
  final String image;
  final bool isActive;

  MyServiceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.price,
    required this.image,
    required this.isActive,
  });
}

class VendorServicesProvider extends ChangeNotifier {
  List<MyServiceModel> services = [
    MyServiceModel(
      id: "1",
      title: "Shirt Sleeve Shortening",
      category: "Tailor Services",
      duration: "3 hours",
      price: 84.13,
      image:
      "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      isActive: true,
    ),
    MyServiceModel(
      id: "2",
      title: "Shirt Sleeve Shortening",
      category: "Tailor Services",
      duration: "3 hours",
      price: 84.13,
      image:
      "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      isActive: false,
    ),
  ];

  void deleteService(String id) {
    services.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void editService(MyServiceModel service) {
    // later API / navigation
  }
}
