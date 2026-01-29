import 'package:flutter/material.dart';
import 'package:ozi/app/core/constants/image_constant.dart';
import 'package:ozi/app/data/repository/repository.dart';
import '../../../profile/save address/model/user_address_model.dart';

class ChangeAddressProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  // ---------------- STATE ----------------
  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Data> _addresses = [];
  List<Data> get addresses => _addresses;

  // ---------------- ICON ----------------
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

  // ---------------- API ----------------
  Future<void> fetchUserAddresses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.getUserAddressApi();
      final model = UserAddressModel.fromJson(response);

      _addresses = model.data ?? [];

      if (_addresses.isNotEmpty && _selectedIndex == -1) {
        final defaultIndex = _addresses.indexWhere((e) => e.isDefault == 1);
        _selectedIndex = defaultIndex != -1 ? defaultIndex : 0;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _addresses = [];
      _selectedIndex = -1;
    }

    _isLoading = false;
    notifyListeners();
  }

  // ---------------- SELECT ----------------
  void selectAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  Data? get selectedAddress {
    if (_selectedIndex >= 0 && _selectedIndex < _addresses.length) {
      return _addresses[_selectedIndex];
    }
    return null;
  }

  // ---------------- FORMAT ----------------
  String getFormattedAddress(Data address) {
    return [
      address.streetAddress,
      address.apartment,
      address.city,
      address.zipCode,
    ].where((e) => e != null && e!.isNotEmpty).join(', ');
  }
}
