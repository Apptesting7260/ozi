import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/service_details.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/models/vendor_home_model.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/response/api_response.dart';

class VendorHomeProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  VendorHomeProvider(){
    getHomeData();
  }


  ApiResponse<VendorHomeModel> _homeModel = ApiResponse.loading();
  ApiResponse<VendorHomeModel> get homeModel => _homeModel;


  setHomeModel(ApiResponse<VendorHomeModel> value){
    _homeModel = value;
    notifyListeners();
  }


  Future<void> getHomeData()async {
    if (kDebugMode) {
      print('getting categories');
    }
    setHomeModel(ApiResponse.loading());
    try {
      final response = await _apiService.getApi(AppUrls.vendorHome);
      if (kDebugMode) {
        print(response);
      }
      setHomeModel(ApiResponse.completed(VendorHomeModel.fromJson(response)));
      checkForUpdateLocationAndIsServiceAvailable();
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      setHomeModel(ApiResponse.error('Internal Server Error'));
    }
  }

  bool _toggleLoading = false;


  Future<void> toggleOnline()async {
    if(_toggleLoading) return;
    _toggleLoading = true;
    try {
      final response = await _apiService.postApi({
        "is_online":(_homeModel.data?.vendorStatus?.isOnline??false)?0:1
      },AppUrls.changeOnlineStatusVendor);
      if (kDebugMode) {
        print(response);
      }
      if(response['status']==true){
        _homeModel.data?.vendorStatus?.isOnline = response['is_online'];
        notifyListeners();
      }
      _toggleLoading = false;
    } catch (e) {
      _toggleLoading = false;
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }

  checkForUpdateLocationAndIsServiceAvailable(){
    if(_homeModel.data?.vendorStatus?.hasLocation==false){
      showLocationPopup(navigatorKey.currentContext!);
    } else if(_homeModel.data?.vendorStatus?.hasService==false){
      _showPopup(navigatorKey.currentContext!);
    }
  }


  bool isEnabled = false;


  // ================= DASHBOARD STATS =================
  double todayEarning = 248.50;
  int activeBookings = 8;
  double walletBalance = 3420.00;
  int totalJobs = 124;

  bool _acceptRejectLoading = false;
  bool get acceptRejectLoading => _acceptRejectLoading;
  updateAcceptLoading(bool value,String bookingId,String status){
    _acceptRejectLoading = value;
    _homeModel.data?.requests?.forEach((e){
      if(status=='accept'){
        e.isLoadingAccept = value;
      }else{
        e.isLoadingReject = value;
      }
    });
    notifyListeners();
  }

  String? currentBookingId;
  String? currentAction;


  Future<void> acceptOrRejectRequest(String status,String bookingId)async {
    if(_acceptRejectLoading) return;
    currentBookingId = bookingId;
    currentAction = status;
    updateAcceptLoading(true,bookingId,status);
    try {
      final response = await _apiService.postApi({
        "booking_id" : bookingId,
        "action" : status
      },AppUrls.acceptRejectBooking);
      if (kDebugMode) {
        print(response);
      }
      _homeModel.data?.requests?.forEach((e){
        if(e.bookingId==bookingId){
          e.status = status;
        }
      });
      updateAcceptLoading(false,bookingId,status);
      currentBookingId = null;
      currentAction = null;
    } catch (e) {
      updateAcceptLoading(false,bookingId,status);
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

  Future<void> updateLocationFromLatLng(LatLng latLng) async {
    try {
      final _ = await _apiService.postApi({
        "latitude": latLng.latitude,
        "longitude": latLng.longitude, //  fixed
      }, AppUrls.vendorUpdateLocation);

    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }


  // latest code

  // void _showPopup(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return WillPopScope(
  //         onWillPop: () async => false,
  //         child: Dialog(
  //           backgroundColor: Colors.transparent,
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
  //             decoration: BoxDecoration(
  //               color:  Color.fromRGBO(207, 209, 212, 1), // light grey background
  //               borderRadius: BorderRadius.circular(24),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //
  //
  //                 Text(
  //                     "Service Unavailable",
  //                     textAlign: TextAlign.center,
  //                     style: AppFontStyle.text_22_600( Color.fromRGBO(28, 29, 33, 1))
  //
  //                 ),
  //
  //                 const SizedBox(height: 12),
  //
  //
  //                 Text(
  //                     "Please Add Service and refresh",
  //                     textAlign: TextAlign.center,
  //                     style:AppFontStyle.text_16_300( Color.fromRGBO(112, 108, 108, 1))
  //
  //                 ),
  //
  //                 const SizedBox(height: 28),
  //
  //
  //                 Row(
  //                   children: [
  //
  //
  //                     Expanded(
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           if (kDebugMode) {
  //                             print("Add pressed");
  //                           }
  //
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) =>
  //                                   ServiceDetailsScreen(null, "Add Service"),
  //                             ),
  //                           ).then((value) {
  //                             if (value == true) {
  //                               Navigator.of(context).pop();
  //                               getHomeData();
  //                             }
  //                           });
  //                         },
  //                         child: Container(
  //                           height: 48,
  //                           alignment: Alignment.center,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(30),
  //                             border: Border.all(
  //                               color: Colors.grey.shade400,
  //                             ),
  //                           ),
  //                           child:  Text(
  //                               "Add",
  //                               style:AppFontStyle.text_16_600( Color.fromRGBO(112, 108, 108, 1))
  //
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //
  //                     const SizedBox(width: 16),
  //
  //
  //                     Expanded(
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           if (kDebugMode) {
  //                             print("Refresh pressed");
  //                           }
  //                           Navigator.of(context).pop();
  //                           getHomeData();
  //                         },
  //                         child: Container(
  //                           height: 48,
  //                           alignment: Alignment.center,
  //                           decoration: BoxDecoration(
  //                             color: AppColors.primary,
  //                             borderRadius: BorderRadius.circular(30),
  //                           ),
  //                           child:  Text(
  //                               "Refresh",
  //                               style:AppFontStyle.text_16_600( Color.fromRGBO(255, 255, 255, 1))
  //
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // Future<void> showLocationPopup(BuildContext context) async {
  //   bool isAlreadyOpen = false;
  //   Navigator.popUntil(context, (route) {
  //     if (route.settings.name == 'location_popup') {
  //       isAlreadyOpen = true;
  //     }
  //     return true;
  //   });
  //
  //   if (isAlreadyOpen) return;
  //
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return WillPopScope(
  //         onWillPop: () async => false,
  //         child: Dialog(
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(24),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //
  //                 Text(
  //                     'Location Required',
  //                     textAlign: TextAlign.center,
  //                     style: AppFontStyle.text_22_600( Color.fromRGBO(28, 29, 33, 1))
  //                 ),
  //
  //                 const SizedBox(height: 12),
  //
  //
  //                 Text(
  //                     'Vendor location not available.\nPlease update your location.',
  //                     textAlign: TextAlign.center,
  //                     style:AppFontStyle.text_16_300( Color.fromRGBO(112, 108, 108, 1))
  //                 ),
  //
  //                 const SizedBox(height: 28),
  //
  //
  //                 Row(
  //                   children: [
  //
  //                     Expanded(
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: Container(
  //                           height: 48,
  //                           alignment: Alignment.center,
  //                           decoration: BoxDecoration(
  //                             color: Colors.transparent,
  //                             borderRadius: BorderRadius.circular(30),
  //                             border: Border.all(
  //                               color: Colors.grey.shade400,
  //                             ),
  //                           ),
  //                           child:  Text(
  //                               'Cancel',
  //                               style:AppFontStyle.text_16_600( Color.fromRGBO(112, 108, 108, 1))
  //
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //
  //                     const SizedBox(width: 16),
  //
  //
  //                     Expanded(
  //                       child: GestureDetector(
  //                         onTap: () async {
  //                           try {
  //                             final LatLng? result =
  //                             await Navigator.pushNamed(
  //                               context,
  //                               '/locationPickerScreen',
  //                             ) as LatLng?;
  //
  //                             if (result != null) {
  //                               await updateLocationFromLatLng(result);
  //                               Navigator.of(context).pop();
  //                               await getHomeData();
  //                             }
  //                           } catch (e) {
  //                             Get.showToast(e.toString(),
  //                                 type: ToastType.error);
  //                           }
  //                         },
  //                         child: Container(
  //                           height: 48,
  //                           alignment: Alignment.center,
  //                           decoration: BoxDecoration(
  //                             color: AppColors.primary, // green button
  //                             borderRadius: BorderRadius.circular(30),
  //                           ),
  //                           child:  Text(
  //                               'Update',
  //                               style:AppFontStyle.text_16_600( Color.fromRGBO(255, 255, 255, 1))
  //
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

// // Helper function to get current location
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return Future.value(false);
          },
          child: AlertDialog(
            title: Text("Service Unavailable"),
            content: Text("Please Add Service and refresh"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Add pressed");
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailsScreen(null, "Add Service"),
                    ),
                  ).then((value) {
                    if (value == true) {
                      Navigator.of(context).pop();
                      getHomeData();
                    }
                  });

                },
                child: Text("Add"),
              ),
              TextButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Refresh pressed");
                  }
                  Navigator.of(context).pop();
                  getHomeData();
                },
                child: Text("Refresh"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showLocationPopup(BuildContext context) async {
    // Prevent showing multiple times by checking the top route
    bool isAlreadyOpen = false;
    Navigator.popUntil(context, (route) {
      if (route.settings.name == 'location_popup') {
        isAlreadyOpen = true;
      }
      return true;
    });

    if (isAlreadyOpen) return;

    // Show dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Location Required'),
            content: const Text(
                'Vendor location not available. Please update your location.'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    ///  Navigate & WAIT for result
                    final LatLng? result =
                    await Navigator.pushNamed(
                      context,
                      '/locationPickerScreen',
                    ) as LatLng?;

                    if (result != null) {

                      await updateLocationFromLatLng(result);

                      Navigator.of(context).pop();

                      await getHomeData();
                    }

                  } catch (e) {
                    Get.showToast(e.toString(), type: ToastType.error);
                  }
                },
                child: const Text('Update'),
              ),

            ],
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
