import 'package:flutter/material.dart';
import '../services/view/CategoryDetailScreen.dart';

class ServiceCategory {
  final String title;
  final String imagePath;
  final Color? overlayColor;

  ServiceCategory({
    required this.title,
    required this.imagePath,
    this.overlayColor,
  });
}

class HomeScreenProvider extends ChangeNotifier {
  String _selectedLocation = "Select Location";
  String _userName = "Alex";

  String get selectedLocation => _selectedLocation;
  String get userName => _userName;

  // Service Categories
  final List<ServiceCategory> _serviceCategories = [
    ServiceCategory(
      title: "Tailor Services",
      imagePath: "https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb",
    ),
    ServiceCategory(
      title: "Entertainment & Event",
      imagePath: "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e",
    ),
    ServiceCategory(
      title: "Towing Services",
      imagePath: "https://images.unsplash.com/photo-1503376780353-7e6692767b70",
    ),
    ServiceCategory(
      title: "Cleaning",
      imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNYwaFbd2pE0CNk7-mOVkCMJJ5XHA8I0Vv4A&s",
    ),
    ServiceCategory(
      title: "Handy Works",
      imagePath: "https://image.shutterstock.com/display_pic_with_logo/732238/128461259/stock-photo-a-female-handy-woman-works-on-a-building-project-in-the-shop-sawing-cutting-boards-128461259.jpg",
    ),
    ServiceCategory(
      title: "Food",
      imagePath: "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe",
    ),
    ServiceCategory(
      title: "Engineering",
      imagePath: "https://www.ucf.edu/wp-content/blogs.dir/19/files/2019/12/how-much-can-you-make-engineering.jpg",
    ),
    ServiceCategory(
      title: "Tutoring",
      imagePath: "https://images.unsplash.com/photo-1503676260728-1c00da094a0b",
    ),
  ];

  List<ServiceCategory> get serviceCategories => _serviceCategories;

  void updateLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void onCategoryTap(String categoryTitle, BuildContext context) {
    // Navigate to category detail screen
    print("Category tapped: $categoryTitle");

    // Import the CategoryDetailScreen and navigate
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailScreen(
          categoryTitle: categoryTitle,
        ),
      ),
    );
  }

  void onBecomeProviderTap(BuildContext context) {
    print("Become a Service Provider tapped");
  }

  void onLocationTap(BuildContext context) {
    print("Location picker tapped");
  }

  void onProfileTap(BuildContext context) {
    print("Profile tapped");
  }

  void onSearchTap(BuildContext context) {
    print("Search tapped");
  }
}