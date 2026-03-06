import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../model/user_address_model.dart';

class SavedAddressProvider extends ChangeNotifier {
  final _repository = Repository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Data> _addresses = [];
  List<Data> get addresses => _addresses;

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  // For editing
  Data? _editingAddress;
  Data? get editingAddress => _editingAddress;

  Data? get defaultAddress => _addresses.firstWhere(
    (addr) => addr.isDefault == true,
    orElse: () => _addresses.isNotEmpty ? _addresses[0] : Data(),
  );

  // Set address for editing
  void setEditingAddress(Data address) {
    _editingAddress = address;
    notifyListeners();
  }

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  String _currentAddress = "Fetching current location...";
  String get currentAddress => _currentAddress;

  // New method to fetch current location
  Future<void> fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _currentAddress = "Location services disabled";
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _currentAddress = "Location permission denied";
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _currentAddress = "Location permission permanently denied";
        notifyListeners();
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocoding for readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentAddress = [
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
          place.country,
        ].where((e) => e?.isNotEmpty == true).join(", ");
      } else {
        _currentAddress =
            "Current Location (${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)})";
      }
    } catch (e) {
      _currentAddress = "Unable to fetch current location";
      print("Current location error: $e");
    }
    notifyListeners();
  }

  // Fetch user addresses
  Future<void> fetchUserAddresses() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    await fetchCurrentLocation();
    try {
      dynamic response = await _repository.getUserAddressApi();

      UserAddressModel addressModel = UserAddressModel.fromJson(response);

      if (addressModel.status == true) {
        _addresses = addressModel.data ?? [];

        // Set default selected index to the default address
        if (_addresses.isNotEmpty) {
          int defaultIndex = _addresses.indexWhere(
            (addr) => addr.isDefault == true,
          );
          _selectedIndex = defaultIndex != -1 ? defaultIndex : 0;
        }
      } else {
        _errorMessage = 'Failed to fetch addresses';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      Get.showToast(e.toString(), type: ToastType.error);
      notifyListeners();
      if (kDebugMode) {
        print('Error fetching addresses: $_errorMessage');
      }
    }
  }

  // Select an address
  void selectAddress(int index) {
    if (index == -2) {
      _selectedIndex = -2;
      notifyListeners();
      return;
    }
    if (index >= 0 && index < _addresses.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  // Get icon based on address type
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

  // Get formatted address
  String getFormattedAddress(Data address) {
    List<String> parts = [];

    if (address.streetAddress?.isNotEmpty == true) {
      parts.add(address.streetAddress!);
    }
    if (address.apartment?.isNotEmpty == true) {
      parts.add(address.apartment!);
    }
    if (address.city?.isNotEmpty == true) {
      parts.add(address.city!);
    }
    if (address.zipCode?.isNotEmpty == true) {
      parts.add(address.zipCode!);
    }

    return parts.join(', ');
  }

  Future<void> deleteAddress(int index, BuildContext context) async {
    if (index < 0 || index >= _addresses.length) return;

    final addressId = _addresses[index].id;

    try {
      final response = await _repository.deleteUserAddressApi(addressId!);

      if (kDebugMode) {
        print("Delete API Response: ${response.toJson()}");
      }

      if (response.status == true) {
        _addresses.removeAt(index);

        // Fix selected index
        if (_selectedIndex >= _addresses.length) {
          _selectedIndex = _addresses.isEmpty ? -1 : _addresses.length - 1;
        }

        notifyListeners();

        if (context.mounted) {
          Get.showToast(
            response.message ?? "Address deleted",
            type: ToastType.success,
          );
        }
      } else {
        throw Exception(response.message ?? "Failed to delete");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Delete Address Error: $e");
      }

      if (context.mounted) {
        Get.showToast(e.toString(), type: ToastType.error);
      }
    }
  }
}
