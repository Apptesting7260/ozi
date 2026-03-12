import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../../save address/model/user_address_model.dart';

class EditUserAddressProvider extends ChangeNotifier {
  final _repository = Repository();

  TextEditingController streetController = TextEditingController();
  TextEditingController apartmentController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  int selectedType = 0;
  bool _initialized = false;
  bool get initialized => _initialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _addressId;
  String? _lat;
  String? _lng;
  bool _disposed = false;
  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

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

  bool _isDefaultAddress = false;
  bool get isDefaultAddress => _isDefaultAddress;

  void toggleDefaultAddress(bool? value) {
    _isDefaultAddress = value ?? false;
    safeNotifyListeners();
  }

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

    if (_initialized && kDebugMode) {
      print("Re-initializing with different address");
    }

    _addressId = address?.id;
    _lat = address?.latitude;
    _lng = address?.longitude;
    if (kDebugMode) {
      print("Setting _addressId to: $_addressId, lat: $_lat, lng: $_lng");
    }

    try {
      if (_lat != null &&
          _lng != null &&
          _lat != "null" &&
          _lng != "null" &&
          _lat!.isNotEmpty &&
          _lng!.isNotEmpty) {
        selectedLatLng = LatLng(double.parse(_lat!), double.parse(_lng!));
        // Set marker without calling notifyListeners (init will do it at the end)
        markers.clear();
        markers.add(
          Marker(
            markerId: const MarkerId("selected"),
            position: selectedLatLng!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueCyan,
            ),
          ),
        );
      } else {
        selectedLatLng = initialLocation;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing lat/lng: $e");
      }
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
        "country": countryController.text.trim(),
        "is_default": _isDefaultAddress ? 1 : 0,
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
    streetController = TextEditingController();
    apartmentController = TextEditingController();
    cityController = TextEditingController();
    zipController = TextEditingController();
  }

  void disposeControllers() {
    streetController.dispose();
    apartmentController.dispose();
    cityController.dispose();
    zipController.dispose();
  }
}
