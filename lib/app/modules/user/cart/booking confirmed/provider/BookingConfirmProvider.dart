import 'package:flutter/material.dart';
import '../../schedule_service/Model/bookingcompletemodel.dart';

class BookingConfirmProvider extends ChangeNotifier {
  final BookingconfirmerdModel? bookingconfirmerdModel;

  BookingConfirmProvider({this.bookingconfirmerdModel});

  List<String> get otp {
    if (bookingconfirmerdModel?.data?.serviceStartOtp != null) {
      return bookingconfirmerdModel!.data!.serviceStartOtp.toString().split('');
    }
    return ["1", "1", "1", "1"];
  }

  String get serviceName {
    if (bookingconfirmerdModel?.data?.services != null &&
        bookingconfirmerdModel!.data!.services!.isNotEmpty) {
      return bookingconfirmerdModel!.data!.services![0].serviceName ?? "";
    }
    return "";
  }

  String get providerName => bookingconfirmerdModel?.data?.vendor?.name ?? "";

  String get bookingDate => bookingconfirmerdModel?.data?.serviceDate ?? "";

  String get bookingTime =>
      bookingconfirmerdModel?.data?.serviceTime?.from ?? "";

  String get address =>
      bookingconfirmerdModel?.data?.address?.streetAddress ?? "";

  String get total => bookingconfirmerdModel?.data?.total ?? "0.00";

  String get bookingCode => bookingconfirmerdModel?.data?.bookingCode ?? "";
}
