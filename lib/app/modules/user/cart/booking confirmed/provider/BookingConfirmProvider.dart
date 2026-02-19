import 'package:flutter/material.dart';
import 'package:ozi/app/data/repository/repository.dart';
import '../../schedule_service/Model/bookingcompletemodel.dart';

class BookingConfirmProvider extends ChangeNotifier {
  BookingconfirmerdModel? bookingconfirmerdModel;
  final _repository = Repository();
  bool _isLoading = false;

  BookingConfirmProvider({this.bookingconfirmerdModel});

  bool get isLoading => _isLoading;

  Future<void> refreshBooking() async {
    final bookingId = bookingconfirmerdModel?.data?.bookingId;
    if (bookingId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // getBookingDetailsApi returns bookingDetailsModel
      final responseModel = await _repository.getBookingDetailsApi(bookingId);
      if (responseModel.status == true && responseModel.data != null) {
        // Since we want to update BookingconfirmerdModel, we can re-map or re-fetch raw
        // But the user's models are very similar. Let's just update the local model from JSON if possible
        // Actually, we can just update the relevant fields or re-parse from model.toJson()
        bookingconfirmerdModel = BookingconfirmerdModel.fromJson(
          responseModel.toJson(),
        );
      }
    } catch (e) {
      debugPrint("Refresh Booking Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> get otp {
    if (bookingconfirmerdModel?.data?.serviceStartOtp != null) {
      return bookingconfirmerdModel!.data!.serviceStartOtp.toString().split('');
    }
    return ["1", "1", "1", "1"];
  }

  List<Services> get services => bookingconfirmerdModel?.data?.services ?? [];

  String get serviceName {
    if (services.isNotEmpty) {
      return services[0].serviceName ?? "";
    }
    return "";
  }

  String get providerName => bookingconfirmerdModel?.data?.vendor?.name ?? "";

  String get bookingDate => bookingconfirmerdModel?.data?.serviceDate ?? "";

  String get bookingTime => bookingconfirmerdModel?.data?.serviceTime ?? "";

  String get address {
    final addr = bookingconfirmerdModel?.data?.address;
    if (addr == null) return "";
    return [
      if (addr.streetAddress?.isNotEmpty == true) addr.streetAddress,
      if (addr.apartment?.isNotEmpty == true) addr.apartment,
      if (addr.city?.isNotEmpty == true) addr.city,
      if (addr.zipCode?.isNotEmpty == true) addr.zipCode,
    ].join(", ");
  }

  String get total => bookingconfirmerdModel?.data?.total ?? "0.00";

  String get bookingCode => bookingconfirmerdModel?.data?.bookingCode ?? "";
}
