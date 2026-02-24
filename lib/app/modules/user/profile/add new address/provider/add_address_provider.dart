import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../model/add_new_address_model.dart';

class AddAddressProvider extends ChangeNotifier {
  final _repository = Repository();
  bool _disposed = false;
  bool _isFetchingAddress = false;

  @override
  void dispose() {
    _disposed = true;
    streetAddressController.dispose();
    apartmentController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // Form Controllers
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  int _selectedType = 0; // 0 = Home, 1 = Work, 2 = Other
  int get selectedType => _selectedType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Google Map State
  GoogleMapController? mapController;
  LatLng? selectedLatLng;
  final Set<Marker> markers = {};

  // Static initial location (Jaipur)
  final LatLng initialLocation = const LatLng(26.9124, 75.7873);

  void setMapController(GoogleMapController ctrl) {
    mapController = ctrl;
  }

  // Get address type string
  String get addressType {
    switch (_selectedType) {
      case 0:
        return 'home';
      case 1:
        return 'work';
      case 2:
        return 'other';
      default:
        return 'home';
    }
  }

  void updateType(int index) {
    _selectedType = index;
    safeNotifyListeners();
  }

  // When user taps map
  Future<void> onMapTap(LatLng latLng) async {
    _updateMarker(latLng);
    await mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  // Move to Current Location
  Future<void> moveToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng latLng = LatLng(position.latitude, position.longitude);

      _updateMarker(latLng); // Update marker immediately
      await mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 17),
        ),
      );
    } catch (e) {
      _errorMessage = "Location permission denied";
      safeNotifyListeners();
    }
  }

  // When map camera stops moving
  Future<void> onCameraIdle(LatLng latLng) async {
    if (_isFetchingAddress) return;
    _updateMarker(latLng);
    await _updateLocationAndAddress(latLng);
  }

  // Helper to update the marker position
  void _updateMarker(LatLng latLng) {
    selectedLatLng = latLng;
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("selected"),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: const InfoWindow(title: "Selected Location"),
      ),
    );
    safeNotifyListeners();
  }

  // Common function for address fetching
  Future<void> _updateLocationAndAddress(LatLng latLng) async {
    if (_disposed || _isFetchingAddress) return;

    _isFetchingAddress = true;
    safeNotifyListeners();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty && !_disposed) {
        Placemark place = placemarks.first;

        streetAddressController.text =
            "${place.street ?? ''} ${place.subLocality ?? ''}".trim();
        cityController.text = place.locality ?? '';
        zipCodeController.text = place.postalCode ?? '';
        countryController.text = place.country ?? '';

        if (cityController.text.isEmpty) {
          cityController.text = place.subAdministrativeArea ?? '';
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Unable to fetch address: $e");
      }
    } finally {
      _isFetchingAddress = false;
      safeNotifyListeners();
    }
  }

  // Validate form
  String? validateForm() {
    if (streetAddressController.text.trim().isEmpty) {
      return 'Please enter street address';
    }
    if (cityController.text.trim().isEmpty) {
      return 'Please enter city';
    }
    if (zipCodeController.text.trim().isEmpty) {
      return 'Please enter ZIP code';
    }
    return null;
  }

  // Add new address
  Future<bool> addNewAddress(BuildContext context) async {
    String? validationError = validateForm();
    if (validationError != null) {
      _errorMessage = validationError;
      safeNotifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationError), backgroundColor: Colors.red),
        );
      }
      return false;
    }

    if (selectedLatLng == null) {
      _errorMessage = 'Please select a location on the map';
      safeNotifyListeners();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a location on the map'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    safeNotifyListeners();

    try {
      Map<String, dynamic> requestData = {
        'street_address': streetAddressController.text.trim(),
        'apartment': apartmentController.text.trim(),
        'city': cityController.text.trim(),
        'zip_code': zipCodeController.text.trim(),
        'country': countryController.text.trim(),
        'address_type': addressType,
        'latitude': selectedLatLng?.latitude.toString(),
        'longitude': selectedLatLng?.longitude.toString(),
        'is_default': 0,
      };

      dynamic response = await _repository.addNewUserAddressApi(requestData);
      AddNewAddressModel addressModel = AddNewAddressModel.fromJson(response);

      _isLoading = false;
      safeNotifyListeners();

      if (addressModel.status == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                addressModel.message ?? 'Address added successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        clearForm();
        return true;
      } else {
        throw Exception(addressModel.message ?? 'Failed to add address');
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      safeNotifyListeners();
      Get.showToast(e.toString(), type: ToastType.error);
      return false;
    }
  }

  void clearForm() {
    streetAddressController.clear();
    apartmentController.clear();
    cityController.clear();
    zipCodeController.clear();
    countryController.clear();
    markers.clear();
    selectedLatLng = null;
    _selectedType = 0;
    _errorMessage = '';
    safeNotifyListeners();
  }
}
