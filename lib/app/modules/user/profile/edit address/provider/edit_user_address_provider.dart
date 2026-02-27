import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../../save address/model/user_address_model.dart';

class EditUserAddressProvider extends ChangeNotifier {
  final _repository = Repository();

  late TextEditingController streetController;
  late TextEditingController apartmentController;
  late TextEditingController cityController;
  late TextEditingController zipController;

  int selectedType = 0;
  bool _initialized = false;
  bool get initialized => _initialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _addressId;
  String? _lat;
  String? _lng;

  // Map related state
  GoogleMapController? mapController;
  LatLng? selectedLatLng;
  final Set<Marker> markers = {};
  bool _isFetchingAddress = false;
  final LatLng initialLocation = const LatLng(26.9124, 75.7873);

  void setMapController(GoogleMapController ctrl) {
    mapController = ctrl;
  }

  void init(Data? address) {
    if (kDebugMode) {
      print(
      "Init called with address ID: ${address?.id}, already initialized: $_initialized",
    );
    }

    // If already initialized with the same address, skip
    if (_initialized && _addressId == address?.id) {
      if (kDebugMode) {
        print("Skipping init - same address");
      }
      return;
    }

    if (_initialized) {
      if (kDebugMode) {
        print("Re-initializing with different address");
      }
      disposeControllers();
    }

    _addressId = address?.id;
    _lat = address?.latitude;
    _lng = address?.longitude;
    if (kDebugMode) {
      print("Setting _addressId to: $_addressId, lat: $_lat, lng: $_lng");
    }

    if (_lat != null &&
        _lng != null &&
        _lat != "null" &&
        _lng != "null" &&
        _lat!.isNotEmpty &&
        _lng!.isNotEmpty) {
      selectedLatLng = LatLng(double.parse(_lat!), double.parse(_lng!));
      _updateMarker(selectedLatLng!);
    } else {
      selectedLatLng = initialLocation;
    }

    streetController = TextEditingController(
      text: address?.streetAddress ?? '',
    );
    apartmentController = TextEditingController(text: address?.apartment ?? '');
    cityController = TextEditingController(text: address?.city ?? '');
    zipController = TextEditingController(text: address?.zipCode ?? '');

    selectedType = _getTypeIndex(address?.addressType);

    _initialized = true;
    notifyListeners();
  }

  int _getTypeIndex(String? type) {
    switch (type?.toLowerCase()) {
      case 'home':
        return 0;
      case 'work':
        return 1;
      default:
        return 2;
    }
  }

  String _getTypeString(int index) {
    switch (index) {
      case 0:
        return 'home';
      case 1:
        return 'work';
      default:
        return 'other';
    }
  }

  void updateType(int index) {
    selectedType = index;
    notifyListeners();
  }

  // Map Interaction Methods
  Future<void> onMapTap(LatLng latLng) async {
    _updateMarker(latLng);
    await mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  Future<void> onCameraIdle(LatLng latLng) async {
    if (_isFetchingAddress) return;
    _updateMarker(latLng);
    await _updateLocationAndAddress(latLng);
  }

  void _updateMarker(LatLng latLng) {
    selectedLatLng = latLng;
    _lat = latLng.latitude.toString();
    _lng = latLng.longitude.toString();
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("selected"),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      ),
    );
    notifyListeners();
  }

  Future<void> _updateLocationAndAddress(LatLng latLng) async {
    if (_isFetchingAddress) return;

    _isFetchingAddress = true;
    notifyListeners();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        streetController.text =
            "${place.street ?? ''} ${place.subLocality ?? ''}".trim();
        cityController.text = place.locality ?? '';
        zipController.text = place.postalCode ?? '';

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
      notifyListeners();
    }
  }

  Future<void> moveToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng latLng = LatLng(position.latitude, position.longitude);

      _updateMarker(latLng);
      await mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 17),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Location permission denied: $e");
      }
    }
  }

  Future<bool> updateAddress(BuildContext context) async {
    if (kDebugMode) {
      print("Address ID : $_addressId");
    }
    if (_addressId == null) {
      Get.showToast("Address ID not found", type: ToastType.error);
      // _showSnackBar(context, "Address ID not found", Colors.red);
      return false;
    }

    // Validation
    if (streetController.text.trim().isEmpty) {
      Get.showToast("Please enter street address", type: ToastType.error);
      // _showSnackBar(context, "Please enter street address", Colors.red);
      return false;
    }
    if (cityController.text.trim().isEmpty) {
      Get.showToast("Please enter city", type: ToastType.error);
      // _showSnackBar(context, "Please enter city", Colors.red);
      return false;
    }
    if (zipController.text.trim().isEmpty) {
      Get.showToast("Please enter ZIP code", type: ToastType.error);
      // _showSnackBar(context, "Please enter ZIP code", Colors.red);
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final data = {
        "address_type": _getTypeString(selectedType),
        "street_address": streetController.text.trim(),
        "apartment": apartmentController.text.trim(),
        "city": cityController.text.trim(),
        "zip_code": zipController.text.trim(),
        "latitude": _lat,
        "longitude": _lng,
      };

      final response = await _repository.editUserAddressApi(_addressId!, data);

      _isLoading = false;
      notifyListeners();

      if (response.status == true) {
        _showSnackBar(
          context,
          response.message ?? "Address updated successfully",
          Colors.green,
        );
        return true;
      } else {
        _showSnackBar(
          context,
          response.message ?? "Failed to update address",
          Colors.red,
        );
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      if (kDebugMode) {
        print("Error updating address: $e");
      }
      _showSnackBar(context, "Failed to update address", Colors.red);
      return false;
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
    }
  }

  void reset() {
    _initialized = false;
    _addressId = null;
    _isLoading = false;
    selectedLatLng = null;
    markers.clear();
  }

  void disposeControllers() {
    if (_initialized) {
      streetController.dispose();
      apartmentController.dispose();
      cityController.dispose();
      zipController.dispose();
    }
  }
}
