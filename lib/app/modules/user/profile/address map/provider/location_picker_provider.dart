import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/utils/get_utils.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/repository/repository.dart';

class LocationPickerProvider extends ChangeNotifier {
  final Repository _repository = Repository();
  final NetworkApiServices _apiService = NetworkApiServices();

  GoogleMapController? _mapController;

  LatLng selectedLatLng = const LatLng(28.6139, 77.2090);
  String address = '';
  bool isLoadingAddress = false;
  bool isLoadingApi = false;

  LatLng? apiLatLng;

  void setController(GoogleMapController controller) {
    _mapController = controller;
    // If we haven't successfully moved to GPS yet, and we don't have an API LatLng, fetch it
    if (apiLatLng == null && address.isEmpty) {
      fetchLatLong();
    } else if (selectedLatLng != const LatLng(28.6139, 77.2090)) {
      // If we already have a custom location (e.g. from GPS), move to it
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLatLng, 16),
      );
    }
  }

  // Fetch lat long from API always
  Future<void> fetchLatLong() async {
    try {
      isLoadingApi = true;
      notifyListeners();

      final response = await _repository.fetchLatLong();

      if (response.status == true && response.data != null) {
        final lat = double.tryParse(response.data!.latitude ?? '');
        final lng = double.tryParse(response.data!.longitude ?? '');

        if (lat != null && lng != null) {
          apiLatLng = LatLng(lat, lng);
          selectedLatLng = apiLatLng!;

          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: selectedLatLng, zoom: 16),
            ),
          );

          await getAddress(selectedLatLng);
        }
      }
    } catch (_) {}

    isLoadingApi = false;
    notifyListeners();
  }

  // Get address from lat long
  Future<void> getAddress(LatLng latLng) async {
    isLoadingAddress = true;
    notifyListeners();

    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      final place = placemarks.first;

      address =
          '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}';
    } catch (_) {
      address = 'Unable to fetch address';
    }

    isLoadingAddress = false;
    notifyListeners();
  }

  // When map moves
  void onCameraMove(CameraPosition position) {
    selectedLatLng = position.target;
  }

  // When map idle
  void onCameraIdle() {
    getAddress(selectedLatLng);
  }

  // Move to current location
  Future<void> moveToCurrentLocation(BuildContext context) async {
    try {
      debugPrint("Starting current location fetch...");
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled.')),
          );
        }
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) _showPermissionDialog(context);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) _showOpenSettingsDialog(context);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      debugPrint("Current location fetched: $latLng");

      selectedLatLng = latLng;
      notifyListeners();

      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
      }

      await getAddress(latLng);
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  Future<void> zoomIn() async {
    final zoom = await _mapController?.getZoomLevel();
    if (zoom != null) {
      _mapController?.animateCamera(CameraUpdate.zoomTo(zoom + 1));
    }
  }

  Future<void> zoomOut() async {
    final zoom = await _mapController?.getZoomLevel();
    if (zoom != null) {
      _mapController?.animateCamera(CameraUpdate.zoomTo(zoom - 1));
    }
  }

  Future<void> updateLocationFromLatLng(LatLng latLng) async {
    try {
      final _ = await _apiService.postApi({
        "latitude": latLng.latitude,
        "longitude": latLng.longitude,
      }, AppUrls.vendorUpdateLocation);
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text(
          "Please allow location access to use current location feature.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.requestPermission();
            },
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

  void _showOpenSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Permission Permanently Denied"),
        content: const Text(
          "Location permission is permanently denied. Please enable it from app settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
