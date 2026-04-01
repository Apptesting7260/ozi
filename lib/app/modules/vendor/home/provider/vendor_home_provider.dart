import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ozi/app/core/device%20info/get_device_Info.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/service_details.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/models/vendor_home_model.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/response/api_response.dart';
import '../../../../data/storage/user_preference.dart';

class VendorHomeProvider extends ChangeNotifier {
  VendorHomeProvider() {
    getLocationFromIP();
  }
  final NetworkApiServices _apiService = NetworkApiServices();

  ApiResponse<VendorHomeModel> _homeModel = ApiResponse.loading();

  ApiResponse<VendorHomeModel> get homeModel => _homeModel;

  setHomeModel(ApiResponse<VendorHomeModel> value) {
    _homeModel = value;
    notifyListeners();
  }

  String cityLocation = "";
  String countryLocation = "";

  Future<void> getHomeData({bool showScreenLoader = true}) async {
    if (kDebugMode) {
      print('getting categories');
    }

    if (showScreenLoader) {
      setHomeModel(ApiResponse.loading());
    }

    try {
      final response = await _apiService.getApi(AppUrls.vendorHome);

      await UserPreference.saveIsDocumentVerified(
        response['vendor_status']['verified_by_admin'] ?? false,
      );

      if (kDebugMode) {
        print(response);
        final savedUserId = await UserPreference.returnIsDocumentVerified();
        print("IsDocumentVerified :  $savedUserId");
      }

      if (kDebugMode) {
        print(response);
      }
      setHomeModel(ApiResponse.completed(VendorHomeModel.fromJson(response)));
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      setHomeModel(ApiResponse.error('Internal Server Error'));
    }
  }

  bool _toggleLoading = false;
  bool _isLoading = false;
  Future<void> toggleOnline() async {
    if (_toggleLoading) return;
    _toggleLoading = true;
    try {
      final response = await _apiService.postApi({
        "is_online": (_homeModel.data?.vendorStatus?.isOnline ?? false) ? 0 : 1,
      }, AppUrls.changeOnlineStatusVendor);
      if (kDebugMode) {
        print(response);
      }
      if (response['status'] == true) {
        _homeModel.data?.vendorStatus?.isOnline = response['is_online'];
        notifyListeners();
      }
      _toggleLoading = false;
    } catch (e) {
      _toggleLoading = false;
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }

  void checkForUpdateLocationAndIsServiceAvailable() {
    if (_homeModel.data?.vendorStatus?.hasLocation == false) {
      showLocationPopup(navigatorKey.currentContext!);
    } else if (_homeModel.data?.vendorStatus?.hasService == false) {
      _showPopup(navigatorKey.currentContext!);
    }
  }

  bool isEnabled = false;

  final Repository _repository = Repository();
  Future<void> getLocationFromIP() async {
    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // CRITICAL: You must assign the values to your class variables
        cityLocation = data['city']?.toString() ?? "";
        countryLocation = data['country']?.toString() ?? "";

        print("Fetched Location: $cityLocation, $countryLocation");
        notifyListeners(); // Tell the UI/Provider that data changed
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching IP location: $e");
    }
  }

  // 2. UPDATED: The backend sender
  Future<void> locationSendToBackend(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ensure we have location before sending
      if (cityLocation.isEmpty || countryLocation.isEmpty) {
        await getLocationFromIP();
      }

      final deviceInfo = await getDeviceInfo();

      Map<String, String> body = {
        "city": cityLocation,
        "country": countryLocation,
        "device_name": deviceInfo["device_name"]?.toString() ?? "",
        "device_id":
            deviceInfo["device_id"]?.toString() ??
            "", // Use the unique ID we fixed earlier!
      };

      final response = await _repository.locationSendToBackend(body);

      if (response != null && response['status'] == true) {
        print("locationSendToBackend success");
      }
    } catch (e) {
      if (kDebugMode) print('Error in locationSendToBackend: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= DASHBOARD STATS =================
  double todayEarning = 248.50;
  int activeBookings = 8;
  double walletBalance = 3420.00;
  int totalJobs = 124;

  bool _acceptRejectLoading = false;

  bool get acceptRejectLoading => _acceptRejectLoading;

  updateAcceptLoading(bool value, String bookingId, String status) {
    _acceptRejectLoading = value;

    _homeModel.data?.requests?.forEach((e) {
      if (e.bookingId == bookingId) {
        if (status == 'accept') {
          e.isLoadingAccept = value;
        } else {
          e.isLoadingReject = value;
        }
      }
    });

    notifyListeners();
  }

  String? currentBookingId;
  String? currentAction;

  Future<void> acceptOrRejectRequest(String status, String bookingId) async {
    if (_acceptRejectLoading) return;
    currentBookingId = bookingId;
    currentAction = status;
    updateAcceptLoading(true, bookingId, status);
    try {
      final response = await _apiService.postApi({
        "booking_id": bookingId,
        "action": status,
      }, AppUrls.acceptRejectBooking);
      if (kDebugMode) {
        print(response);
      }
      _homeModel.data?.requests?.forEach((e) {
        if (e.bookingId == bookingId) {
          e.status = status;
        }
      });
      updateAcceptLoading(false, bookingId, status);
      currentBookingId = null;
      currentAction = null;
    } catch (e) {
      updateAcceptLoading(false, bookingId, status);
      currentBookingId = null;
      currentAction = null;
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }

  // Future<void> updateLocation(Position? location)async {
  //   if(location==null) return;
  //   try {
  //     final response = await _apiService.postApi({
  //       "latitude" : location.latitude,
  //       "longitude" : location.longitude
  //     },AppUrls.vendorUpdateLocation);
  //     getHomeData();
  //   } catch (e) {
  //     getHomeData();
  //     Get.showToast(e.toString(), type: ToastType.error);
  //   }
  // }

  String address = '';
  String city = '';
  String state = '';
  String country = '';

  Future<void> updateLocationFromLatLng(LatLng latLng) async {
    try {
      if (kDebugMode) {
        print({
          "latitude": latLng.latitude,
          "longitude": latLng.longitude,
          "address": address,
          "city": city,
          "state": state,
          "country": country,
        });
      }

      final _ = await _apiService.postApi({
        "latitude": latLng.latitude,
        "longitude": latLng.longitude,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
      }, AppUrls.vendorUpdateLocation);
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }

  bool _popupLoading = false;

  bool get popupLoading => _popupLoading;

  void _setPopupLoading(bool value) {
    _popupLoading = value;
    notifyListeners();
  }

  Future<void> _showPopup(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Consumer<VendorHomeProvider>(
                builder: (context, provider, _) {
                  if (provider.popupLoading) {
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Service Unavailable",
                        textAlign: TextAlign.center,
                        style: AppFontStyle.text_22_600(
                          Color.fromRGBO(28, 29, 33, 1),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Please Add Service and refresh",
                        textAlign: TextAlign.center,
                        style: AppFontStyle.text_16_300(
                          Color.fromRGBO(112, 108, 108, 1),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServiceDetailsScreen(
                                      null,
                                      "Add Service",
                                    ),
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    Navigator.of(context).pop();
                                    checkForUpdateLocationAndIsServiceAvailable();
                                    getHomeData();
                                  }
                                });
                              },
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                child: Text(
                                  "Add",
                                  style: AppFontStyle.text_16_600(
                                    const Color.fromRGBO(112, 108, 108, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                _setPopupLoading(true);
                                await getHomeData(showScreenLoader: false);
                                _setPopupLoading(false);

                                if (_homeModel.data?.vendorStatus?.hasService ==
                                    true) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  "Refresh",
                                  style: AppFontStyle.text_16_600(
                                    const Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showLocationPopup(BuildContext context) async {
    bool isAlreadyOpen = false;
    Navigator.popUntil(context, (route) {
      if (route.settings.name == 'location_popup') {
        isAlreadyOpen = true;
      }
      return true;
    });

    if (isAlreadyOpen) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      //   barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Location Required',
                    textAlign: TextAlign.center,
                    style: AppFontStyle.text_22_600(
                      Color.fromRGBO(28, 29, 33, 1),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Vendor location not available.\nPlease update your location.',
                    textAlign: TextAlign.center,
                    style: AppFontStyle.text_16_300(
                      Color.fromRGBO(112, 108, 108, 1),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppFontStyle.text_16_600(
                                Color.fromRGBO(112, 108, 108, 1),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              final result =
                                  await Navigator.pushNamed(
                                        context,
                                        '/locationPickerScreen',
                                      )
                                      as Map<String, dynamic>?;

                              if (result != null) {
                                final LatLng latLng = result["latLng"];

                                // ✅ SET DATA BEFORE API CALL
                                address = result["address"] ?? '';
                                city = result["city"] ?? '';
                                state = result["state"] ?? '';
                                country = result["country"] ?? '';

                                await updateLocationFromLatLng(latLng);
                                Navigator.of(context).pop();

                                await getHomeData(showScreenLoader: false);
                                checkForUpdateLocationAndIsServiceAvailable();
                              }
                            } catch (e) {
                              Get.showToast(
                                e.toString(),
                                type: ToastType.error,
                              );
                            }
                          },
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary, // green button
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Update',
                              style: AppFontStyle.text_16_600(
                                Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

enum BookingStatus { newRequest, confirmed }

class BookingRequest {
  final String customerName;
  final String service;
  final double price;
  final String date;
  final String time;
  final String address;
  final BookingStatus status;

  BookingRequest({
    required this.customerName,
    required this.service,
    required this.price,
    required this.date,
    required this.time,
    required this.address,
    required this.status,
  });

  BookingRequest copyWith({BookingStatus? status}) {
    return BookingRequest(
      customerName: customerName,
      service: service,
      price: price,
      date: date,
      time: time,
      address: address,
      status: status ?? this.status,
    );
  }
}
