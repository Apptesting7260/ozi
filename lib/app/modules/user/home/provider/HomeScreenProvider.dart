import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../data/repository/repository.dart';
import '../model/category_model.dart';
import '../services/view/CategoryDetailScreen.dart';

class HomeScreenProvider extends ChangeNotifier {
  HomeScreenProvider() {
    getCurrentLocation();
    print("lat long value lat=$lat, lng=$lng");
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

    await fetchCategories();

    _isLoading = false;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    await fetchCategories();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      final CategoryModel model = await _repository.homePageCategoryApi(
        lat ?? "",
        lng ?? "",
      );

      _serviceCategories.clear();
      print("lat lonhg : $lat $lng");
      if (model.status == true &&
          model.data != null &&
          model.data!.isNotEmpty) {
        _serviceCategories.addAll(model.data!);
      }
      notifyListeners();
    } catch (e) {
      Get.showToast(
        e.toString() ?? 'Something went wrong',
        type: ToastType.error,
      );
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

      // GPS on
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location denied. Please enable location services");
        return false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission denied.");
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permission denied");
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      lat = position.latitude.toStringAsFixed(6);
      lng = position.longitude.toStringAsFixed(6);

      print("Latitude value: ${lat.toString()}");
      print("Longitude value: ${lng.toString()}");

      notifyListeners(); // Notify UI about location update

      await fetchCategories();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        countryName = place.country;
        countryCode = place.isoCountryCode;

        // Update selected location with a more readable address
        _selectedLocation = "${place.locality ?? ""}, ${place.country ?? ""}";
        if (_selectedLocation.startsWith(", ")) {
          _selectedLocation = _selectedLocation.substring(2);
        }

        print("Country: $countryName");
        print("Country Code: $countryCode");
        print("Location Address: $_selectedLocation");
        notifyListeners();
      }
      return true; // success
    } catch (e) {
      Get.showToast(
        e.toString() ?? 'Something went wrong',
        type: ToastType.error,
      );
      print("Location error: $e");
      return false;
    }
  }

  void onBecomeProviderTap(BuildContext context) {}
  void onLocationTap(BuildContext context) {}
  void onProfileTap(BuildContext context) {}
  void onSearchTap(BuildContext context) {}
}
