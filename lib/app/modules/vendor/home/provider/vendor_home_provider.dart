import 'package:flutter/material.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/service_details.dart';
import 'package:ozi/app/modules/user/home/service%20details/view/ServiceDetailScreen.dart';

import '../../../../core/constants/app_urls.dart';
import '../../../../core/utils/get_utils.dart';
import '../../../../data/models/vendor_home_model.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/response/api_response.dart';
import '../../../../data/storage/user_preference.dart';
import 'package:geolocator/geolocator.dart';

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
    print('getting categories');
    setHomeModel(ApiResponse.loading());
    try {
      final response = await _apiService.getApi(AppUrls.vendorHome);
      print(response);
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
      print(response);
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
      print(response);
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

  Future<void> updateLocation(Position? location)async {
    if(location==null) return;
    try {
      final response = await _apiService.postApi({
        "latitude" : location.latitude,
        "longitude" : location.longitude
      },AppUrls.vendorUpdateLocation);
      getHomeData();
    } catch (e) {
      getHomeData();
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }

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
                  print("Add pressed");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(),));
                  // Navigator.of(context).pop();
                },
                child: Text("Add"),
              ),
              TextButton(
                onPressed: () {
                  print("Refresh pressed");
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
      barrierDismissible: false, // Cannot dismiss by tapping outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button
          child: AlertDialog(
            title: const Text('Location Required'),
            content: const Text(
                'Vendor location not available. Please update your location.'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Get current location
                    Position position = await _determinePosition();
                    print('Lat: ${position.latitude}, Lng: ${position.longitude}');
                    updateLocation(position);
                    Navigator.of(context).pop();
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

// Helper function to get current location
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

}

// ===================================================
// MODELS
// ===================================================




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
