import 'package:flutter/material.dart';

class CheckoutProvider extends ChangeNotifier {
  String selectedAddressTitle = "Home";
  String address =
      "123 Main Street, San Francisco, CA 94102";

  String paymentType = "Credit Card";
  String cardNumber = "•••• 4242";

  double subtotal = 168.26;
  double serviceFee = 5.00;

  double get total => subtotal + serviceFee;
}
