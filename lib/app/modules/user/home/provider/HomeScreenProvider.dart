import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../data/repository/repository.dart';
import '../../../../data/storage/user_preference.dart';
import '../model/category_model.dart';
import '../services/view/CategoryDetailScreen.dart';
import '../../cart/change address/provider/ChangeAddressProvider.dart';
import '../../../../core/utils/location_permission_helper.dart';

class HomeScreenProvider extends ChangeNotifier {
  HomeScreenProvider() {
    // Location and data will be handled by loadOnce() called from the View
  }

  // Session-based consent map: userId -> hasConsented
  // This is stored only in-memory (within the app) as requested.
  static final Map<String, bool> _sessionConsentMap = {};

  static void setSessionConsent(String userId, bool hasConsented) {
    _sessionConsentMap[userId] = hasConsented;
  }

  static bool hasGuestConsent() {
    return _sessionConsentMap['guest'] ?? false;
  }

  static void promoteGuestConsent(String userId) {
    if (hasGuestConsent()) {
      _sessionConsentMap[userId] = true;
      debugPrint("Consent promoted from guest to user: $userId");
    }
  }

  static void clearAllConsent() {
    _sessionConsentMap.clear();
  }

  String _selectedLocation = "Select Location";
  final String _userName = "Alex";

  final TextEditingController searchController = TextEditingController();

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

  DateTime? _lastFetchTime;

  bool hasSessionConsent(String? userId) {
    return _sessionConsentMap[userId ?? "guest"] ?? false;
  }

  bool _isManualLocation = false;

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

  Future<void> loadOnce(BuildContext context) async {
    final String userId = await UserPreference.returnUserId() ?? "guest";
    debugPrint(
      "loadOnce: userId=$userId, isLoaded=$_isLoaded, lastFetchTime=$_lastFetchTime",
    );

    // If already loaded and within 30 mins, and we have consent, just return
    if (_isLoaded &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!).inMinutes < 30) {
      debugPrint("loadOnce: Already loaded within 30 mins. Skipping.");
      return;
    }

    // Restore consent from persistent storage if not already in memory
    if (!(_sessionConsentMap[userId] ?? false)) {
      final persistedConsent = await UserPreference.returnLocationConsent();
      debugPrint("loadOnce: persistedConsent from storage = $persistedConsent");
      if (persistedConsent == true) {
        _sessionConsentMap[userId] = true;
        debugPrint("Restored location consent from storage for user: $userId");
      }
    } else {
      debugPrint("loadOnce: Already have in-memory consent for user: $userId");
    }

    // Check session consent
    if (!(_sessionConsentMap[userId] ?? false)) {
      debugPrint("loadOnce: No consent found. Showing dialog...");
      if (context.mounted) {
        await requestLocationPermission(context);
      }
      return;
    }

    debugPrint("loadOnce: Consent found. Fetching location...");

    _isLoading = true;
    notifyListeners();

    bool success = await getCurrentLocation();
    if (success) {
      _isLoaded = true;
      _lastFetchTime = DateTime.now();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    _isManualLocation = false; // Reset manual flag on manual refresh
    notifyListeners();

    bool success = await getCurrentLocation();
    if (success) {
      _isLoaded = true;
      _lastFetchTime = DateTime.now();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    if (lat == null || lng == null || lat!.isEmpty || lng!.isEmpty) {
      debugPrint(
        "⚠️ Skipping Category API: Location not available : lat $lat, lng : $lng",
      );
      return;
    }

    // Only show shimmer if we don't have any data yet
    bool shouldShowShimmer = _serviceCategories.isEmpty;
    if (shouldShowShimmer) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final CategoryModel model = await _repository.homePageCategoryApi(
        lat!,
        lng!,
      );

      if (model.status == true && model.data != null) {
        _serviceCategories.clear();
        _serviceCategories.addAll(model.data!);
        debugPrint(
          "Category API Success: Found ${_serviceCategories.length} categories",
        );
      } else {
        debugPrint("Category API returned status false or empty data");
        // We might want to clear here if we want to show "No Services"
        _serviceCategories.clear();
      }
    } catch (e) {
      debugPrint("❌ Category API Error: $e");
      // Keep existing categories on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  Future<void> updateFromSelection(
    int index,
    ChangeAddressProvider addressProvider,
  ) async {
    _isManualLocation = true; // Mark that user has manually chosen a location
    _isLoading = true;
    notifyListeners();

    if (index == -2) {
      // Current location
      if (addressProvider.currentLocationAddress != null) {
        _selectedLocation = addressProvider.currentLocationAddress!;
        if (addressProvider.currentLat != null) {
          lat = addressProvider.currentLat!.toStringAsFixed(6);
          lng = addressProvider.currentLng!.toStringAsFixed(6);
        }
      }
    } else if (index >= 0 && index < addressProvider.addresses.length) {
      final address = addressProvider.addresses[index];
      _selectedLocation = addressProvider.getFormattedAddress(address);

      String? newLat = address.latitude;
      String? newLng = address.longitude;

      // Fallback: If lat/lng is missing, try geocoding the address string
      if (newLat == null ||
          newLat.isEmpty ||
          newLat == "null" ||
          newLng == null ||
          newLng.isEmpty ||
          newLng == "null") {
        debugPrint(
          "Coordinates missing for selected address, trying geocode...",
        );

        try {
          List<Location> locations = await locationFromAddress(
            _selectedLocation,
          ).timeout(const Duration(seconds: 5));

          if (locations.isNotEmpty) {
            newLat = locations.first.latitude.toStringAsFixed(6);
            newLng = locations.first.longitude.toStringAsFixed(6);
            debugPrint("Successfully geocoded address to: $newLat, $newLng");
          }
        } catch (e) {
          debugPrint("Geocoding failed: $e");
        }
      }

      lat = newLat;
      lng = newLng;
      if (kDebugMode) {
        print("updateFromSelection lat  = $lat");
      }
      if (kDebugMode) {
        print("updateFromSelection lng = $lng");
      }
    }
    notifyListeners();
    await fetchCategories(); // Wait for categories to be fetched
    _isLoading = false;
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

  void resetState() {
    _isLoaded = false;
    _isLoading = false;
    _isManualLocation = false;
    _selectedLocation = "Select Location";
    lat = null;
    lng = null;
    _serviceCategories.clear();

    // Clear session consent on reset (logout) to ensure we ask again on next login
    _sessionConsentMap.clear();
    // Also clear persisted consent (it gets cleared via clearSharedPreference too,
    // but this is explicit for clarity)
    UserPreference.saveLocationConsent(false);

    notifyListeners();
  }

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

      // If user has manually selected an address in the meantime, don't stomp on it
      if (_isManualLocation) {
        debugPrint("Ignoring auto-GPS update: Manual location is already set.");
        return true;
      }

      // Indicate loading start for address specifically
      _selectedLocation = "Fetching location...";
      notifyListeners();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Final check before updating state
      if (_isManualLocation) return true;

      lat = position.latitude.toStringAsFixed(6);
      lng = position.longitude.toStringAsFixed(6);

      // Fallback in case geocoding fails
      _selectedLocation = "Current Location";
      notifyListeners();

      // Fetch categories even if geocoding hasn't finished
      await fetchCategories();

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(const Duration(seconds: 5));

        // Re-check manual flag after geocoding too
        if (_isManualLocation) return true;

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          countryName = place.country;
          countryCode = place.isoCountryCode;
          _selectedLocation = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
        }
      } catch (geocodingError) {
        debugPrint("Geocoding failed: $geocodingError");
        // Keep "Current Location"
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Location error: $e");
      if (_selectedLocation == "Fetching location...") {
        _selectedLocation = "Location error";
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> showLocationConsentDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              backgroundColor: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 22,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Allow Location Access",
                      style: AppFontStyle.text_18_600(
                        AppColors.black,
                        fontFamily: AppFontFamily.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "We need your location to show available services near you. Your location is only used while the app is active in this session.",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: AppFontStyle.text_14_400(AppColors.grey),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: "Allow",
                      borderRadius: BorderRadius.circular(30),
                      onPressed: () => Navigator.pop(dialogContext, true),
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: "Don't Allow",
                      isOutlined: true,
                      borderRadius: BorderRadius.circular(30),
                      onPressed: () => Navigator.pop(dialogContext, false),
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    final String userId = await UserPreference.returnUserId() ?? "guest";
    debugPrint(
      "requestLocationPermission: userId=$userId, currentConsent=${_sessionConsentMap[userId]}",
    );

    // If we don't have session consent yet, ask explicitly via our custom dialog
    if (!(_sessionConsentMap[userId] ?? false)) {
      bool consented = await showLocationConsentDialog(context);
      if (!consented) {
        debugPrint("User declined session location consent.");
        return;
      }
      // Save consent immediately after user agrees in dialog
      _sessionConsentMap[userId] = true;
      await UserPreference.saveLocationConsent(true);
      debugPrint("Location consent saved for user: $userId");
    }

    // Now check/request OS level permission
    if (await LocationPermissionHelper.handleLocationPermission(context)) {
      _isLoading = true;
      notifyListeners();

      bool success = await getCurrentLocation();

      _isLoading = false;

      if (success) {
        _isLoaded = true;
        Get.showToast('Location updated successfully', type: ToastType.success);
      }

      notifyListeners();
    }
  }

  void onBecomeProviderTap(BuildContext context) {}
  void onLocationTap(BuildContext context) {
    requestLocationPermission(context);
  }

  void onProfileTap(BuildContext context) {}
  void onSearchTap(BuildContext context) {}

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
