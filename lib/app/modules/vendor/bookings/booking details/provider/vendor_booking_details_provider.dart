




import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/models/booking_detail_model.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/response/api_response.dart';

class VendorBookingDetailsProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  TextEditingController pinController = TextEditingController();

  String? errorMessage;

  updateErrorMessage(String? value){
    errorMessage = value;
    notifyListeners();
  }

  bool _isOpenOtpBox = false;
  bool get isOpenOtpBox => _isOpenOtpBox;
  updateIsOpenOtpBox(bool value){
    _isOpenOtpBox = value;
    notifyListeners();
  }


  VendorBookingDetailsProvider(bookingId){
    getAllBookings(bookingId);
  }


  ApiResponse<BookingDetailModel> _homeModel = ApiResponse.loading();
  ApiResponse<BookingDetailModel> get homeModel => _homeModel;

  setHomeModel(ApiResponse<BookingDetailModel> value){
    _homeModel = value;
    notifyListeners();
  }


  Future<void> getAllBookings(String bookingId)async {

    print('getting categories');
    try {
      setHomeModel(ApiResponse.loading());
      final response = await _apiService.getApi(AppUrls.vendorMyBookingsDetails.replaceAll("{bookingid}", bookingId));
      setHomeModel(ApiResponse.completed(BookingDetailModel.fromJson(response)));
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      setHomeModel(ApiResponse.error('Internal Server Error'));
    }
  }

  bool _otpVerifyLoading = false;
  bool get otpVerifyLoading => _otpVerifyLoading;
  updateOtpVerifyLoading(bool value){
    _otpVerifyLoading = value;
    notifyListeners();
  }


  Future<void> verifyOtp(String bookingId)async {
    if(_otpVerifyLoading) return;
    if(pinController.text.length<4){
      errorMessage = 'Please Enter Pin';
      notifyListeners();
      return;
    }else{
      errorMessage = null;
      notifyListeners();
    }
    print('getting categories');
    try {
      updateOtpVerifyLoading(true);
      final response = await _apiService.postApi({
        "otp":pinController.text,
        "booking_id":bookingId
      },AppUrls.vendorOtpVerify);
      getAllBookings(bookingId);
      updateOtpVerifyLoading(false);
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      updateOtpVerifyLoading(false);
    }
  }

  bool _completeJobLoading = false;
  bool get completeJobLoading => _completeJobLoading;
  updateCompleteJobLoading(bool value){
    _completeJobLoading = value;
    notifyListeners();
  }


  Future<void> completeTheJob(String bookingId)async {
    if(_completeJobLoading) return;
    try {
      updateOtpVerifyLoading(true);
      final response = await _apiService.postApi({
        "booking_id":bookingId
      },AppUrls.completeJob);
      getAllBookings(bookingId);
      updateCompleteJobLoading(false);
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      updateCompleteJobLoading(false);
    }
  }



  // // Call customer
  // Future<void> callCustomer() async {
  //   try {
  //     final uri = Uri.parse("tel:${booking.phone}");
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri);
  //     }
  //   } catch (e) {
  //     debugPrint("Error calling customer: $e");
  //   }
  // }
  //
  // // Navigate to customer location
  Future<void> navigateToCustomer() async {
    // try {
    //   final encodedAddress = Uri.encodeComponent(_homeModel.data?.data?.address?.fullAddress??'');
    //   final uri = Uri.parse(
    //     "https://www.google.com/maps/search/?api=1&query=$encodedAddress",
    //   );
    //
    //   if (await canLaunchUrl(uri)) {
    //     await launchUrl(uri, mode: LaunchMode.externalApplication);
    //   }
    // } catch (e) {
    //   debugPrint("Error navigating: $e");
    // }
    final encodedAddress = Uri.encodeComponent(_homeModel.data?.data?.address?.fullAddress??'');
    final googleMapsUri = Uri.parse("googlemaps://?q=$encodedAddress");
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback to the browser if Google Maps is not available
      final browserUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$encodedAddress");
      await launchUrl(browserUri, mode: LaunchMode.externalApplication);
    }

  }
  //
  // // Complete job
  // Future<void> completeJob(BuildContext context) async {
  //   isProcessing = true;
  //   notifyListeners();
  //
  //   // Simulate API call
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   isProcessing = false;
  //   notifyListeners();
  //
  //   if (context.mounted) {
  //     // Show success dialog
  //     showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //         title: const Text("Success"),
  //         content: const Text("Job marked as completed!"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(ctx); // Close dialog
  //               Navigator.pop(context); // Go back to list
  //             },
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
  //
  // // Start job (for upcoming bookings)
  // Future<void> startJob(BuildContext context) async {
  //   isProcessing = true;
  //   notifyListeners();
  //
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   isProcessing = false;
  //   notifyListeners();
  //
  //   if (context.mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Job started!")),
  //     );
  //   }
  // }
  //
  // // Verify OTP (optional feature from screens)
  // Future<void> verifyOTP(BuildContext context, String otp) async {
  //   isProcessing = true;
  //   notifyListeners();
  //
  //   // Simulate OTP verification
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   isProcessing = false;
  //   notifyListeners();
  //
  //   if (context.mounted) {
  //     // Navigate or show success
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("OTP Verified!")),
  //     );
  //   }
  // }
}