import 'package:flutter/material.dart';
import '../../../../../core/constants/image_constant.dart';
import '../../../../../data/repository/repository.dart';
import '../model/user_address_model.dart';

class SavedAddressProvider extends ChangeNotifier {
  final _repository = Repository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Data> _addresses = [];
  List<Data> get addresses => _addresses;

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  // For editing
  Data? _editingAddress;
  Data? get editingAddress => _editingAddress;

  Data? get defaultAddress =>
      _addresses.firstWhere((addr) => addr.isDefault == 1, orElse: () => _addresses.isNotEmpty ? _addresses[0] : Data());

  // Set address for editing
  void setEditingAddress(Data address) {
    _editingAddress = address;
    notifyListeners();
  }

  // Fetch user addresses
  Future<void> fetchUserAddresses() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      dynamic response = await _repository.getUserAddressApi();

      UserAddressModel addressModel = UserAddressModel.fromJson(response);

      if (addressModel.status == true) {
        _addresses = addressModel.data ?? [];

        // Set default selected index to the default address
        if (_addresses.isNotEmpty) {
          int defaultIndex = _addresses.indexWhere((addr) => addr.isDefault == 1);
          _selectedIndex = defaultIndex != -1 ? defaultIndex : 0;
        }
      } else {
        _errorMessage = 'Failed to fetch addresses';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      print('Error fetching addresses: $_errorMessage');
    }
  }

  // Select an address
  void selectAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  // Get icon based on address type
  String getIconForAddressType(String? type) {
    switch (type?.toLowerCase()) {
      case 'home':
        return ImageConstants.home2;
      case 'work':
        return ImageConstants.work;
      default:
        return ImageConstants.location;
    }
  }

  // Get formatted address
  String getFormattedAddress(Data address) {
    List<String> parts = [];

    if (address.streetAddress?.isNotEmpty == true) {
      parts.add(address.streetAddress!);
    }
    if (address.apartment?.isNotEmpty == true) {
      parts.add(address.apartment!);
    }
    if (address.city?.isNotEmpty == true) {
      parts.add(address.city!);
    }
    if (address.zipCode?.isNotEmpty == true) {
      parts.add(address.zipCode!);
    }

    return parts.join(', ');
  }

  Future<void> deleteAddress(int index, BuildContext context) async {
    if (index < 0 || index >= _addresses.length) return;

    final addressId = _addresses[index].id;

    try {
      final response = await _repository.deleteUserAddressApi(addressId!);

      print("Delete API Response: ${response.toJson()}");

      if (response.status == true) {
        _addresses.removeAt(index);

        // Fix selected index
        if (_selectedIndex >= _addresses.length) {
          _selectedIndex = _addresses.isEmpty ? -1 : _addresses.length - 1;
        }

        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? "Address deleted"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception(response.message ?? "Failed to delete");
      }

    } catch (e) {
      print("Delete Address Error: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete address"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}