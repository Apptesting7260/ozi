import 'package:flutter/material.dart';
import '../../../../../data/repository/repository.dart';
import '../model/add_new_address_model.dart';

class AddAddressProvider extends ChangeNotifier {
  final _repository = Repository();

  // Form Controllers
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  int _selectedType = 0; // 0 = Home, 1 = Work, 2 = Other
  int get selectedType => _selectedType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Get address type string
  String get addressType {
    switch (_selectedType) {
      case 0:
        return 'home';
      case 1:
        return 'work';
      case 2:
        return 'other';
      default:
        return 'home';
    }
  }

  void updateType(int index) {
    _selectedType = index;
    notifyListeners();
  }

  // Validate form
  String? validateForm() {
    if (streetAddressController.text.trim().isEmpty) {
      return 'Please enter street address';
    }
    if (cityController.text.trim().isEmpty) {
      return 'Please enter city';
    }
    if (zipCodeController.text.trim().isEmpty) {
      return 'Please enter ZIP code';
    }
    return null;
  }

  // Add new address
  Future<bool> addNewAddress(BuildContext context) async {
    // Validate
    String? validationError = validateForm();
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(validationError),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Prepare request data
      Map<String, dynamic> requestData = {
        'street_address': streetAddressController.text.trim(),
        'apartment': apartmentController.text.trim(),
        'city': cityController.text.trim(),
        'zip_code': zipCodeController.text.trim(),
        'address_type': addressType,
        'is_default': 0, // Set to 1 if you want this to be default
      };

      print('Adding new address: $requestData');

      // Call API
      dynamic response = await _repository.addNewUserAddressApi(requestData);

      // Parse response
      AddNewAddressModel addressModel = AddNewAddressModel.fromJson(response);

      _isLoading = false;
      notifyListeners();

      if (addressModel.status == true) {
        // Success
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(addressModel.message ?? 'Address added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Clear form
        clearForm();

        return true;
      } else {
        throw Exception(addressModel.message ?? 'Failed to add address');
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();

      print('Error adding address: $_errorMessage');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add address: $_errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }

      return false;
    }
  }

  // Clear form
  void clearForm() {
    streetAddressController.clear();
    apartmentController.clear();
    cityController.clear();
    zipCodeController.clear();
    _selectedType = 0;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    streetAddressController.dispose();
    apartmentController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }
}