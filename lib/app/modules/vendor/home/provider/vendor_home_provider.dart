import 'package:flutter/material.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/service_details.dart';
import 'package:ozi/app/modules/user/home/service%20details/view/ServiceDetailScreen.dart';

import '../../../../core/constants/app_urls.dart';
import '../../../../core/utils/get_utils.dart';
import '../../../../data/models/vendor_home_model.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/response/api_response.dart';
import '../../../../data/storage/user_preference.dart';

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
    if(_homeModel.data?.vendorStatus?.hasService==false){
      _showPopup(navigatorKey.currentContext!);
    }
    if(_homeModel.data?.vendorStatus?.hasLocation==false){

    }
  }


  bool isEnabled = false;


  // ================= DASHBOARD STATS =================
  double todayEarning = 248.50;
  int activeBookings = 8;
  double walletBalance = 3420.00;
  int totalJobs = 124;

  // ================= BOOKINGS LIST =================
  // final List<BookingRequest> _newRequests = [
  //   BookingRequest(
  //     customerName: "Alex Johnson",
  //     service: "Deep Cleaning",
  //     price: 84.13,
  //     date: "Today",
  //     time: "2:00 PM",
  //     address: "123 Main St, San Francisco",
  //     status: BookingStatus.newRequest,
  //   ),
  // ];
  //
  // final List<BookingRequest> _confirmedRequests = [
  //   BookingRequest(
  //     customerName: "Alex Johnson",
  //     service: "Deep Cleaning",
  //     price: 84.13,
  //     date: "Tomorrow",
  //     time: "2:00 PM",
  //     address: "123 Main St, San Francisco",
  //     status: BookingStatus.confirmed,
  //   ),
  // ];
  //
  // List<BookingRequest> get newRequests => _newRequests;
  // List<BookingRequest> get confirmedRequests => _confirmedRequests;
  //
  // // ================= ACTIONS =================
  // void acceptRequest(int index) {
  //   final request = _newRequests.removeAt(index);
  //   _confirmedRequests.add(
  //     request.copyWith(status: BookingStatus.confirmed),
  //   );
  //   notifyListeners();
  // }
  //
  // void rejectRequest(int index) {
  //   _newRequests.removeAt(index);
  //   notifyListeners();
  // }

  bool _acceptRejectLoading = false;
  bool get acceptRejectLoading => _acceptRejectLoading;
  updateAcceptLoading(bool value){
    _acceptRejectLoading = value;
    notifyListeners();
  }

  String? currentBookingId;
  String? currentAction;


  Future<void> acceptOrRejectRequest(String status,String bookingId)async {
    if(_acceptRejectLoading) return;
    currentBookingId = bookingId;
    currentAction = status;
    updateAcceptLoading(true);
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
      updateAcceptLoading(false);
      currentBookingId = null;
      currentAction = null;
    } catch (e) {
      updateAcceptLoading(false);
      currentBookingId = null;
      currentAction = null;
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
