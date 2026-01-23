import 'package:flutter/material.dart';
import '../../../../../data/repository/repository.dart';
import '../../save address/model/user_address_model.dart';

class EditUserAddressProvider extends ChangeNotifier {
  final _repository = Repository();

  late TextEditingController streetController;
  late TextEditingController apartmentController;
  late TextEditingController cityController;
  late TextEditingController zipController;

  int selectedType = 0;
  bool _initialized = false;
  bool get initialized => _initialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _addressId;

  void init(Data? address) {
    if (_initialized) return;

    _addressId = address?.id;

    streetController =
        TextEditingController(text: address?.streetAddress ?? '');
    apartmentController =
        TextEditingController(text: address?.apartment ?? '');
    cityController =
        TextEditingController(text: address?.city ?? '');
    zipController =
        TextEditingController(text: address?.zipCode ?? '');

    selectedType = _getTypeIndex(address?.addressType);

    _initialized = true;
    notifyListeners();
  }

  int _getTypeIndex(String? type) {
    switch (type?.toLowerCase()) {
      case 'home':
        return 0;
      case 'work':
        return 1;
      default:
        return 2;
    }
  }

  String _getTypeString(int index) {
    switch (index) {
      case 0:
        return 'home';
      case 1:
        return 'work';
      default:
        return 'other';
    }
  }

  void updateType(int index) {
    selectedType = index;
    notifyListeners();
  }

  Future<bool> updateAddress(BuildContext context) async {
    if (_addressId == null) {
      _showSnackBar(context, "Address ID not found", Colors.red);
      return false;
    }

    // Validation
    if (streetController.text.trim().isEmpty) {
      _showSnackBar(context, "Please enter street address", Colors.red);
      return false;
    }
    if (cityController.text.trim().isEmpty) {
      _showSnackBar(context, "Please enter city", Colors.red);
      return false;
    }
    if (zipController.text.trim().isEmpty) {
      _showSnackBar(context, "Please enter ZIP code", Colors.red);
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final data = {
        "address_type": _getTypeString(selectedType),
        "street_address": streetController.text.trim(),
        "apartment": apartmentController.text.trim(),
        "city": cityController.text.trim(),
        "zip_code": zipController.text.trim(),
      };

      final response = await _repository.editUserAddressApi(_addressId!, data);

      _isLoading = false;
      notifyListeners();

      if (response.status == true) {
        _showSnackBar(
          context,
          response.message ?? "Address updated successfully",
          Colors.green,
        );
        return true;
      } else {
        _showSnackBar(
          context,
          response.message ?? "Failed to update address",
          Colors.red,
        );
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      print("Error updating address: $e");
      _showSnackBar(context, "Failed to update address", Colors.red);
      return false;
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );
    }
  }

  void reset() {
    _initialized = false;
    _addressId = null;
    _isLoading = false;
  }

  void disposeControllers() {
    streetController.dispose();
    apartmentController.dispose();
    cityController.dispose();
    zipController.dispose();
  }
}