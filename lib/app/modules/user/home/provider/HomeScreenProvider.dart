import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../data/repository/repository.dart';
import '../model/category_model.dart';
import '../services/view/CategoryDetailScreen.dart';

class HomeScreenProvider extends ChangeNotifier {
  HomeScreenProvider() {
    // Location and data will be handled by loadOnce() called from the View
  }
  String _selectedLocation = "Select Location";
  final String _userName = "Alex";

  String? lat;
  String? lng;
  String? countryCode;
  String? countryName;
  bool _isLoaded = false;
  bool _isLoading = false;

  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  String get selectedLocation => _selectedLocation;
  String get userName => _userName;

  final List<Data> _serviceCategories = [];
  List<Data> get serviceCategories => _serviceCategories;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Data> get filteredCategories {
    if (_searchQuery.trim().isEmpty) {
      return _serviceCategories;
    }
    return _serviceCategories
        .where(
          (element) =>
              element.categoryName?.toLowerCase().contains(
                _searchQuery.trim().toLowerCase(),
              ) ??
              false,
        )
        .toList();
  }

  final Repository _repository = Repository();

  Future<void> loadOnce() async {
    if (_isLoaded) return;
    _isLoading = true;
    notifyListeners();

    bool success = await getCurrentLocation();
    if (success) {
      _isLoading = false;
      _isLoaded = true;
    }
    // If not successful, we keep _isLoading = true to show shimmer
    // as per user requirement.
    notifyListeners();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    bool success = await getCurrentLocation();
    if (success) {
      _isLoading = false;
      _isLoaded = true;
    }
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    if (lat == null || lng == null || lat!.isEmpty || lng!.isEmpty) {
      debugPrint("⚠️ Skipping Category API: Location not available");
      return;
    }

    try {
      final CategoryModel model = await _repository.homePageCategoryApi(
        lat!,
        lng!,
      );

      _serviceCategories.clear();
      if (model.status == true &&
          model.data != null &&
          model.data!.isNotEmpty) {
        _serviceCategories.addAll(model.data!);
      }
      notifyListeners();
    } catch (e) {
      // Avoid showing errors if it's related to missing location or expected issues
      debugPrint("❌ Category API Error: $e");
    }
  }

  void updateLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void onCategoryTap(Data category, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(category: category),
      ),
    );
  }
  // Future<void> refreshData() async {
  //   await fetchCategories();
  // }

  Future<bool> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.showToast(
          'Please enable location services',
          type: ToastType.notice,
        );
        return false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.showToast(
            'Location permission is required.',
            type: ToastType.error,
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.showToast(
          'Location permission is required.',
          type: ToastType.error,
        );
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      lat = position.latitude.toStringAsFixed(6);
      lng = position.longitude.toStringAsFixed(6);

      await fetchCategories();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        countryName = place.country;
        countryCode = place.isoCountryCode;
        _selectedLocation = "${place.locality ?? ""}, ${place.country ?? ""}";
        if (_selectedLocation.startsWith(", ")) {
          _selectedLocation = _selectedLocation.substring(2);
        }
      }
      return true;
    } catch (e) {
      debugPrint("Location error: $e");
      return false;
    }
  }

  void onBecomeProviderTap(BuildContext context) {}
  void onLocationTap(BuildContext context) {}
  void onProfileTap(BuildContext context) {}
  void onSearchTap(BuildContext context) {}
}
