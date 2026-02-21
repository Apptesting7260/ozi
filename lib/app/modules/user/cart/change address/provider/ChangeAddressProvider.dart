import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/core/constants/image_constant.dart';
import 'package:ozi/app/core/utils/get_utils.dart';
import 'package:ozi/app/data/repository/repository.dart';
import '../../../profile/save address/model/user_address_model.dart';

class ChangeAddressProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  // ---------------- STATE ----------------
  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Data> _addresses = [];
  List<Data> get addresses => _addresses;

  String? _currentLocationAddress;
  String? get currentLocationAddress => _currentLocationAddress;

  double? _currentLat;
  double? get currentLat => _currentLat;

  double? _currentLng;
  double? get currentLng => _currentLng;

  bool _isUsingCurrentLocation = false;
  bool get isUsingCurrentLocation => _isUsingCurrentLocation;

  bool _isLocationLoading = false;
  bool get isLocationLoading => _isLocationLoading;

  // ---------------- ICON ----------------
  String getIconForAddressType(String? type) {
    switch (type?.toLowerCase()) {
      case 'home':
        return ImageConstants.home2;
      case 'work':
        return ImageConstants.work;
      default:
        return ImageConstants.location;
    }
  }

  // ---------------- API ----------------
  Future<void> fetchUserAddresses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.getUserAddressApi();
      final model = UserAddressModel.fromJson(response);

      _addresses = model.data ?? [];

      if (_addresses.isNotEmpty && _selectedIndex == -1) {
        final defaultIndex = _addresses.indexWhere((e) => e.isDefault == 1);
        _selectedIndex = defaultIndex != -1 ? defaultIndex : 0;
      }
    } catch (e) {
      Get.showToast(
        e.toString() ?? 'Something went wrong',
        type: ToastType.error,
      );
      _errorMessage = e.toString();
      _addresses = [];
      _selectedIndex = -1;
    }

    _isLoading = false;
    notifyListeners();
  }

  // ---------------- SELECT ----------------
  void selectAddress(int index) {
    _isUsingCurrentLocation = false;
    if (index >= 0 && index < _addresses.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  Future<void> useCurrentLocation() async {
    _isLocationLoading = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.showToast(
          'Please enable location services',
          type: ToastType.notice,
        );
        _isLocationLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.showToast(
            'Location permission is required.',
            type: ToastType.error,
          );
          _isLocationLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.showToast(
          'Location permission is permanently denied.',
          type: ToastType.error,
        );
        _isLocationLoading = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        // Construct full address: Street, Area, City
        _currentLocationAddress = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        _currentLat = position.latitude;
        _currentLng = position.longitude;

        _isUsingCurrentLocation = true;
        _selectedIndex = -2; // Special index for current location
      }
    } catch (e) {
      debugPrint("Location error: $e");
      Get.showToast('Failed to get location: $e', type: ToastType.error);
    }

    _isLocationLoading = false;
    notifyListeners();
  }

  Data? get selectedAddress {
    if (_selectedIndex >= 0 && _selectedIndex < _addresses.length) {
      return _addresses[_selectedIndex];
    }
    return null;
  }

  // ---------------- FORMAT ----------------
  String getFormattedAddress(Data address) {
    return [
      address.streetAddress,
      address.apartment,
      address.city,
      address.zipCode,
    ].where((e) => e != null && e!.isNotEmpty).join(', ');
  }
}
