import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' hide Location;
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

  bool _isLocationPermissionDenied = false;
  bool get isLocationPermissionDenied => _isLocationPermissionDenied;

  bool _isDefaultAddress = false;
  bool get isDefaultAddress => _isDefaultAddress;

  void toggleDefaultAddress(bool? value) {
    _isDefaultAddress = value ?? false;
    safeNotifyListeners();
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    _isLocationPermissionDenied =
        (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever);
    safeNotifyListeners();
  }

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
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _isLocationPermissionDenied = true;
          _errorMessage = "Location permission denied";
          safeNotifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _isLocationPermissionDenied = true;
        _errorMessage = "Location permission permanently denied";
        safeNotifyListeners();
        return;
      }

      _isLocationPermissionDenied = false;

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
      _errorMessage = "Error fetching location: $e";
      safeNotifyListeners();
    }
  }

  // When map camera stops moving
  Future<void> onCameraIdle(LatLng latLng) async {
    if (_isFetchingAddress) return;
    _updateMarker(latLng);
    await _updateLocationAndAddress(latLng);
    if (streetAddressController.text.trim().length < 12) {
      await _tryGooglePlacesReverseGeocode(latLng);
    }
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

  Future<void> _updateLocationAndAddress(LatLng latLng) async {
    if (_disposed || _isFetchingAddress) return;

    _isFetchingAddress = true;
    safeNotifyListeners();

    try {
      // Optional: Set desired locale once (you can also call this in initState or earlier)
      // Best place: call it once when provider initializes or app starts
      // await setLocaleIdentifier("en_IN");   // Uncomment if you want India-English style

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty && !_disposed) {
        // Pick the most useful placemark (first is usually good, but we try to improve)
        Placemark? bestPlace;
        for (var place in placemarks) {
          if ((place.thoroughfare?.isNotEmpty ?? false) ||
              (place.subThoroughfare?.isNotEmpty ?? false)) {
            bestPlace = place;
            break;
          }
        }
        bestPlace ??= placemarks.first;

        String fullStreetAddress =
            [
                  bestPlace.name,
                  bestPlace.subThoroughfare,
                  bestPlace.thoroughfare,
                  bestPlace.subLocality,
                  bestPlace.locality,
                  bestPlace.subAdministrativeArea,
                ]
                .where((s) => s != null && s.isNotEmpty)
                .cast<String>()
                .fold<List<String>>([], (acc, s) {
                  if (acc.every(
                    (existing) =>
                        !existing.contains(s) && !s.contains(existing),
                  )) {
                    acc.add(s);
                  }
                  return acc;
                })
                .join(', ')
                .trim();

        if (fullStreetAddress.isEmpty) {
          fullStreetAddress = bestPlace.name ?? 'Unknown location';
        }

        // Update controllers (no 'mounted' check needed here)
        streetAddressController.text = fullStreetAddress;
        cityController.text =
            bestPlace.locality ?? bestPlace.subAdministrativeArea ?? '';
        zipCodeController.text = bestPlace.postalCode ?? '';
        countryController.text = bestPlace.country ?? 'India';

        // Optional: you can also fill apartment / landmark if useful
        // apartmentController.text = bestPlace.name ?? '';
      }
    } catch (e) {
      debugPrint("Reverse geocoding error: $e");
      // Optionally show toast / error to user
    } finally {
      _isFetchingAddress = false;
      if (!_disposed) {
        safeNotifyListeners();
      }
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

  Future<void> _tryGooglePlacesReverseGeocode(LatLng latLng) async {
    try {
      final places = GoogleMapsPlaces(apiKey: AddAddressProvider.kGoogleApiKey);

      final response = await places.searchNearbyWithRadius(
        Location(lat: latLng.latitude, lng: latLng.longitude),
        50, // 50 meters radius
        type: "street_address|premise|establishment",
      );

      if (response.isOkay && response.results.isNotEmpty) {
        final best = response.results.first;
        streetAddressController.text = best.formattedAddress ?? "";
        // ya fir best.name + best.vicinity use kar sakte ho
        safeNotifyListeners();
      }
    } catch (e) {
      debugPrint("Google nearby reverse failed: $e");
    }
  }

  // Add new address
  Future<bool> addNewAddress(BuildContext context) async {
    String? validationError = validateForm();
    if (validationError != null) {
      _errorMessage = validationError;
      safeNotifyListeners();

      if (context.mounted) {
        Get.showToast(validationError, type: ToastType.error);
      }
      return false;
    }

    if (selectedLatLng == null) {
      _errorMessage = 'Please select a location on the map';
      safeNotifyListeners();
      if (context.mounted) {
        Get.showToast(
          "Please select a location on the map",
          type: ToastType.error,
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
        'is_default': _isDefaultAddress ? 1 : 0,
      };

      dynamic response = await _repository.addNewUserAddressApi(requestData);
      AddNewAddressModel addressModel = AddNewAddressModel.fromJson(response);

      _isLoading = false;
      safeNotifyListeners();

      if (addressModel.status == true) {
        if (context.mounted) {
          Get.showToast(
            addressModel.message ?? 'Address added successfully',
            type: ToastType.success,
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

  static const String kGoogleApiKey = "AIzaSyApdA5sIEfZoPmhlWuAr5wTgyOXvhl9jsQ";

  Future<void> showLocationSearch(BuildContext context) async {
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "in")],
      hint: "Search area, street name, landmark...",
      location: selectedLatLng != null
          ? Location(
              lat: selectedLatLng!.latitude,
              lng: selectedLatLng!.longitude,
            )
          : null,
      radius: 50000, // suggestions nearby bias
      offset: 0,
    );

    if (prediction != null && prediction.placeId != null) {
      await _processSelectedPlace(prediction, context);
    }
  }

  Future<void> selectManualPlace(Prediction prediction) async {
    if (prediction.placeId == null) return;

    final places = GoogleMapsPlaces(
      apiKey: "AIzaSyApdA5sIEfZoPmhlWuAr5wTgyOXvhl9jsQ",
    );
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(
      prediction.placeId!,
      fields: ["address_components", "geometry", "formatted_address"],
    );
    if (!detail.isOkay || detail.result.geometry == null) return;

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    final newLatLng = LatLng(lat, lng);

    // Update marker (if you have one)
    _updateMarker(newLatLng);
    try {
      final detail = await places.getDetailsByPlaceId(
        prediction.placeId!,
        fields: ["address_components", "geometry", "formatted_address"],
      );

      if (!detail.isOkay || detail.result.geometry == null) return;

      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      final newLatLng = LatLng(lat, lng);

      // Update map
      await mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newLatLng, zoom: 17),
        ),
      );

      _updateMarker(newLatLng);

      // Fill fields
      String street = "",
          subLocality = "",
          city = "",
          postal = "",
          country = "";

      for (var comp in detail.result.addressComponents) {
        final types = comp.types;
        if (types.contains("street_number") || types.contains("route")) {
          street += "${comp.longName} ";
        }
        if (types.contains("sublocality")) subLocality = comp.longName;
        if (types.contains("locality")) city = comp.longName;
        if (types.contains("postal_code")) postal = comp.longName;
        if (types.contains("country")) country = comp.longName;
      }

      streetAddressController.text =
          detail.result.formattedAddress ??
          "${street.trim()} ${subLocality.trim()}".trim();
      cityController.text = city;
      zipCodeController.text = postal;
      countryController.text = country;

      apartmentController.text =
          prediction.description?.split(', ').skip(1).take(2).join(', ') ?? "";

      safeNotifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error in selectManualPlace: $e");
      }
    }
  }

  Future<void> _processSelectedPlace(
    Prediction prediction,
    BuildContext context,
  ) async {
    final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(
      prediction.placeId!,
      fields: ["address_components", "geometry", "formatted_address"],
    );

    if (!detail.isOkay || detail.result.geometry == null) {
      // Optional: show error toast
      return;
    }

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    final newLatLng = LatLng(lat, lng);

    // Map update (existing map safe rahega)
    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newLatLng, zoom: 17),
      ),
    );

    // Marker if needed (central pin already handle kar raha hai)
    _updateMarker(newLatLng);

    // Fields fill
    String street = "";
    String subLocality = "";
    String city = "";
    String postal = "";
    String country = "";

    for (var comp in detail.result.addressComponents) {
      final types = comp.types;
      if (types.contains("street_number") || types.contains("route")) {
        street += "${comp.longName} ";
      }
      if (types.contains("sublocality")) subLocality = comp.longName;
      if (types.contains("locality")) city = comp.longName;
      if (types.contains("postal_code")) postal = comp.longName;
      if (types.contains("country")) country = comp.longName;
    }

    streetAddressController.text =
        detail.result.formattedAddress ??
        "${street.trim()} ${subLocality.trim()}".trim();
    cityController.text = city;
    zipCodeController.text = postal;
    countryController.text = country;

    // Landmark / extra info
    apartmentController.text =
        prediction.description ??
        prediction.description?.split(', ').skip(1).take(2).join(', ') ??
        "";

    safeNotifyListeners();
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
    _isDefaultAddress = false;
    _errorMessage = '';
    safeNotifyListeners();
  }
}
