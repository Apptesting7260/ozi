import 'package:flutter/material.dart';

import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/utils/get_utils.dart';
import '../../../../../data/models/vendor_home_model.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/response/api_response.dart';

enum BookingStatus { newRequest, confirmed }

class BookingRequest {
  final String name;
  final String service;
  final String date;
  final String time;
  final String address;
  final double price;
  final BookingStatus status;

  BookingRequest({
    required this.name,
    required this.service,
    required this.date,
    required this.time,
    required this.address,
    required this.price,
    required this.status,
  });
}

class NewRequestsProvider extends ChangeNotifier {
  NewRequestsProvider(){
    getAllRequests();
  }

  final NetworkApiServices _apiService = NetworkApiServices();

  ApiResponse<VendorAllRequestsModel> _requestModel = ApiResponse.loading();
  ApiResponse<VendorAllRequestsModel> get requestModel => _requestModel;

  setHomeModel(ApiResponse<VendorAllRequestsModel> value){
    _requestModel = value;
    notifyListeners();
  }


  Future<void> getAllRequests()async {
    print('getting categories');
    setHomeModel(ApiResponse.loading());
    try {
      final response = await _apiService.getApi(AppUrls.vendorHome);
      print(response);
      setHomeModel(ApiResponse.completed(VendorAllRequestsModel.fromJson(response)));
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      setHomeModel(ApiResponse.error('Internal Server Error'));
    }
  }

  bool _acceptRejectLoading = false;
  bool get acceptRejectLoading => _acceptRejectLoading;
  updateAcceptLoading(bool value,String bookingId,String status){
    _acceptRejectLoading = value;
    _requestModel.data?.requests?.forEach((e){
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
      _requestModel.data?.requests?.forEach((e){
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

  // final List<BookingRequest> _requests = [
  //   BookingRequest(
  //     name: "Alex Johnson",
  //     service: "Deep Cleaning",
  //     date: "Today",
  //     time: "2:00 PM",
  //     address: "123 Main St, San Francisco",
  //     price: 84.13,
  //     status: BookingStatus.newRequest,
  //   ),
  //   BookingRequest(
  //     name: "Alex Johnson",
  //     service: "Deep Cleaning",
  //     date: "Today",
  //     time: "2:00 PM",
  //     address: "123 Main St, San Francisco",
  //     price: 84.13,
  //     status: BookingStatus.newRequest,
  //   ),
  //   BookingRequest(
  //     name: "Alex Johnson",
  //     service: "Deep Cleaning",
  //     date: "Tomorrow",
  //     time: "2:00 PM",
  //     address: "123 Main St, San Francisco",
  //     price: 84.13,
  //     status: BookingStatus.confirmed,
  //   ),
  // ];
  //
  // List<BookingRequest> get requests => _requests;
  //
  // void acceptRequest(int index) {
  //   _requests[index] =
  //       BookingRequest(
  //         name: _requests[index].name,
  //         service: _requests[index].service,
  //         date: _requests[index].date,
  //         time: _requests[index].time,
  //         address: _requests[index].address,
  //         price: _requests[index].price,
  //         status: BookingStatus.confirmed,
  //       );
  //   notifyListeners();
  // }
  //
  // void rejectRequest(int index) {
  //   _requests.removeAt(index);
  //   notifyListeners();
  // }
}
