import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
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
    if (kDebugMode) {
      print('getting categories');
    }
    setHomeModel(ApiResponse.loading());
    try {
      final response = await _apiService.getApi(AppUrls.vendorHome);
      if (kDebugMode) {
        print(response);
      }
      setHomeModel(ApiResponse.completed(VendorAllRequestsModel.fromJson(response)));
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      setHomeModel(ApiResponse.error('Internal Server Error'));
    }
  }

  final Set<String> _loadingBookings = {};

  bool isBookingLoading(String bookingId) =>
      _loadingBookings.contains(bookingId);




  String? currentBookingId;



  String? currentAction;


  Future<bool> acceptOrRejectRequest(
      String action,
      String bookingId,
      ) async {
    if (_loadingBookings.contains(bookingId)) return false;

    final requests = _requestModel.data?.requests;
    if (requests == null) return false;

    final index =
    requests.indexWhere((e) => e.bookingId == bookingId);

    if (index == -1) return false;

    final request = requests[index];

    // Start loading for this specific booking
    _loadingBookings.add(bookingId);

    if (action == 'accept') {
      request.isLoadingAccept = true;
    } else {
      request.isLoadingReject = true;
    }

    notifyListeners();

    try {
      await _apiService.postApi(
        {
          "booking_id": bookingId,
          "action": action,
        },
        AppUrls.acceptRejectBooking,
      );

      // Stop loading
      request.isLoadingAccept = false;
      request.isLoadingReject = false;

      // Update status locally
      request.status =
      action == 'accept' ? 'confirmed' : 'rejected';

      _loadingBookings.remove(bookingId);
      notifyListeners();

      return true;
    } catch (e) {
      request.isLoadingAccept = false;
      request.isLoadingReject = false;

      _loadingBookings.remove(bookingId);
      notifyListeners();

      Get.showToast(e.toString(), type: ToastType.error);
      return false;
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
