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

  // 🔒 Load-once flag - prevents repeated API calls
  // Yeh flag permanent rahega jab tak app kill nahi hogi
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

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

  /// ✅ Perfect Load Once Implementation
  /// Yeh function sirf pehli baar run hoga
  /// Navigation ke baad wapas aane par bhi nahi chalega
  void loadOnce() {
    // Check: Agar pehle se loaded hai toh return kar do
    if (_isLoaded) {
      print("✅ Data already loaded, skipping API call");
      return;
    }

    print("🔄 Loading data for the first time...");

    // 🔥 YAHAN APNA API CALL LAGAO
    // Example:
    // _fetchUserData();
    // _fetchServiceCategories();
    // await apiService.getUserProfile();

    // Simulate API call (remove this in production)
    // Future.delayed(Duration(seconds: 2), () {
    //   _userName = "Alex Kumar";
    //   _selectedLocation = "Jaipur, Rajasthan";
    //   notifyListeners();
    // });

    // Flag ko true kar do taaki dobara load na ho
    _isLoaded = true;
    notifyListeners();
  }

  /// Optional: Force reload (agar kabhi manual refresh chahiye)
  void forceReload() {
    _isLoaded = false;
    loadOnce();
  }

  void updateLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void onCategoryTap(String categoryTitle, BuildContext context) {
    print("Category tapped: $categoryTitle");
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
    // Navigate to become provider screen
  }

  void onLocationTap(BuildContext context) {
    print("Location picker tapped");
    // Show location picker dialog/bottom sheet
  }

  void onProfileTap(BuildContext context) {
    print("Profile tapped");
    // Navigate to profile screen
  }

  void onSearchTap(BuildContext context) {
    print("Search tapped");
    // Navigate to search screen
  }
}