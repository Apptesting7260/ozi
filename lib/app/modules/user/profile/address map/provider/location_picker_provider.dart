import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ozi/app/core/appExports/app_export.dart';

import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/utils/get_utils.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../vendor/home/provider/vendor_home_provider.dart';
import '../../view/profile_provider/profile_provider.dart';

class LocationPickerProvider extends ChangeNotifier {
  GoogleMapController? controller;


  LatLng? selectedLatLng;
  String? selectedAddress;

  final Set<Marker> markers = {};

  // Static initial location (Jaipur)
  final LatLng initialLocation =
  const LatLng(26.9124, 75.7873);

  void setController(GoogleMapController ctrl) {
    controller = ctrl;
  }

  // When user taps map
  Future<void> onTap(LatLng latLng) async {
    await _setMarkerAndAddress(latLng);
  }

  // Move to Current Location
  Future<void> moveToCurrentLocation() async {
    try {
      Position position =
      await Geolocator.getCurrentPosition(
          desiredAccuracy:
          LocationAccuracy.high);

      LatLng latLng =
      LatLng(position.latitude, position.longitude);

      await controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 17),
        ),
      );

      await _setMarkerAndAddress(latLng);
    } catch (e) {
      selectedAddress = "Location permission denied";
      notifyListeners();
    }
  }

  // Common function for marker + address
  Future<void> _setMarkerAndAddress(
      LatLng latLng) async {
    selectedLatLng = latLng;
    selectedAddress = "Fetching address...";

    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("selected"),
        position: latLng,
        infoWindow: const InfoWindow(
            title: "Selected Location"),
      ),
    );

    notifyListeners();

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(
          latLng.latitude,
          latLng.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        selectedAddress =
        "${place.street ?? ''}, "
            "${place.locality ?? ''}, "
            "${place.administrativeArea ?? ''}, "
            "${place.country ?? ''}";
      }
    } catch (e) {
      selectedAddress = "Unable to fetch address";
    }

    notifyListeners();
  }

  void zoomIn() {
    controller?.animateCamera(
        CameraUpdate.zoomIn());
  }

  void zoomOut() {
    controller?.animateCamera(
        CameraUpdate.zoomOut());
  }
}
