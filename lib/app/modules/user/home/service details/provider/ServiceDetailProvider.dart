import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:ozi/app/core/utils/get_utils.dart';
import 'package:ozi/app/data/response/api_response.dart';
import 'package:ozi/app/modules/user/home/service%20details/model/vendordetaiulmodel.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/repository/repository.dart';
import '../../model/category_model.dart' hide Data;
import '../model/ServiceDetailsModel.dart';
import '../model/add_to_cart.dart';

class ServiceDetailProvider extends ChangeNotifier {
  final Subcategories service;
  final int categoryId;
  final Repository _repository = Repository();

  ApiResponse<vendorDetailModel> _vendorDetailData = ApiResponse.loading();
  ApiResponse<vendorDetailModel> get vendorDetailData => _vendorDetailData;

  void setVendorDetailModel(ApiResponse<vendorDetailModel> value) {
    _vendorDetailData = value;
    notifyListeners();
  }

  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    dev.log('Search query updated: "$_searchQuery"');
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    searchController.clear();
    dev.log('Search cleared');
    notifyListeners();
  }

  List<Data> get filteredVendorServices {
    final allServices = _vendorDetailData.data?.data ?? [];
    dev.log(
      'Filtering ${allServices.length} services with query: "$_searchQuery"',
    );

    if (_searchQuery.trim().isEmpty) {
      return allServices;
    }

    final query = _searchQuery.trim().toLowerCase();
    return allServices.where((service) {
      final name = service.serviceName?.toLowerCase() ?? '';
      final description = service.description?.toLowerCase() ?? '';
      final match = name.contains(query) || description.contains(query);
      if (match) {
        dev.log('Match found: ${service.serviceName}');
      }
      return match;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  ServiceDetailProvider(this.service, this.categoryId) {
    _fetchServiceDetails();
  }

  Future<void> vendorDetailsApi(String vendorId) async {
    try {
      setVendorDetailModel(ApiResponse.loading());
      final response = await _repository.vendorDetailsApi(vendorId);
      setVendorDetailModel(ApiResponse.completed(response));
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      setVendorDetailModel(ApiResponse.error(e.toString()));
    }
  }

  List<ServiceData> _serviceProviders = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAddingToCart = false;

  List<ServiceData> get serviceProviders => _serviceProviders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAddingToCart => _isAddingToCart;

  final Map<int, int> _cartItems = {};

  Future<void> _fetchServiceDetails() async {
    if (service.id == null) {
      _errorMessage = 'Invalid subcategory ID';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      dev.log(
        'Fetching services - Category ID: $categoryId, Subcategory ID: ${service.id}',
      );

      final response = await _repository.serviceDetailsApi(
        categoryId,
        service.id!,
      );

      dev.log('API Response - Status: ${response.status}');
      dev.log('API Response - Message: ${response.message}');
      dev.log('API Response - Data Count: ${response.data?.length ?? 0}');

      if (response.status == true) {
        _serviceProviders = response.data ?? [];
        if (_serviceProviders.isEmpty) {
          _errorMessage = 'No services available';
        }
      } else {
        _errorMessage = response.message ?? 'Failed to load services';
      }
    } catch (e) {
      _errorMessage = 'Error loading services';
      dev.log('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _fetchServiceDetails();
  }

  bool isInCart(int serviceId) {
    return _cartItems.containsKey(serviceId) && _cartItems[serviceId]! > 0;
  }

  int getQuantity(int serviceId) {
    return _cartItems[serviceId] ?? 0;
  }

  Future<bool> addToCart(int serviceId) async {
    try {
      _isAddingToCart = true;
      notifyListeners();

      Map<String, dynamic> requestData = {
        'service_id': serviceId,
        'quantity': 1,
      };

      dev.log('Adding to cart - Request Data: $requestData');
      dev.log('API URL: ${AppUrls.addToCartApi}');

      // API CALL
      final response = await _repository.addToCartApi(requestData);

      dev.log('Add to Cart API Raw Response: $response');
      dev.log('Response Type: ${response.runtimeType}');

      // Parse correctly
      AddToCartModel addToCartResponse = response;

      if (addToCartResponse.status == true) {
        _cartItems[serviceId] = addToCartResponse.data?.quantity ?? 1;

        dev.log('Successfully added to cart: Service ID $serviceId');

        _isAddingToCart = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(addToCartResponse.message ?? 'Failed to add to cart');
      }
    } catch (e) {
      dev.log('Error adding to cart: $e');
      dev.log('Error type: ${e.runtimeType}');
      _isAddingToCart = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> incrementQuantity(int serviceId) async {
    if (_cartItems.containsKey(serviceId)) {
      try {
        _isAddingToCart = true;
        notifyListeners();

        final newQuantity = _cartItems[serviceId]! + 1;

        // Find the service details
        final serviceData = _serviceProviders.firstWhere(
          (sp) => sp.id == serviceId,
          orElse: () => ServiceData(),
        );

        // Prepare API data
        Map<String, dynamic> requestData = {
          'service_id': serviceId,
          'quantity': newQuantity,
        };

        dev.log('Incrementing quantity - Request Data: $requestData');

        // Call the API
        final response = await _repository.addToCartApi(requestData);

        Map<String, dynamic> jsonResponse;
        if (response is Map<String, dynamic>) {
          jsonResponse = requestData;
        } else {
          throw Exception('Invalid response format');
        }

        // Parse the response
        AddToCartModel addToCartResponse = AddToCartModel.fromJson(
          jsonResponse,
        );

        if (addToCartResponse.status == true) {
          _cartItems[serviceId] = newQuantity;
          dev.log('Incremented: Service ID $serviceId to $newQuantity');
          _isAddingToCart = false;
          notifyListeners();
          return true;
        } else {
          throw Exception(addToCartResponse.message ?? 'Failed to update cart');
        }
      } catch (e) {
        dev.log('Error incrementing quantity: $e');
        _isAddingToCart = false;
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  Future<bool> decrementQuantity(int serviceId) async {
    if (_cartItems.containsKey(serviceId)) {
      try {
        _isAddingToCart = true;
        notifyListeners();

        final currentQuantity = _cartItems[serviceId]!;

        if (currentQuantity > 1) {
          final newQuantity = currentQuantity - 1;

          // Prepare API data
          Map<String, dynamic> requestData = {
            'service_id': serviceId,
            'quantity': newQuantity,
          };

          dev.log('Decrementing quantity - Request Data: $requestData');

          // Call the API
          final response = await _repository.addToCartApi(requestData);

          Map<String, dynamic> jsonResponse;
          if (response is Map<String, dynamic>) {
            jsonResponse = requestData;
          } else {
            throw Exception('Invalid response format');
          }

          AddToCartModel addToCartResponse = AddToCartModel.fromJson(
            jsonResponse,
          );

          if (addToCartResponse.status == true) {
            _cartItems[serviceId] = newQuantity;
            dev.log('Decremented: Service ID $serviceId to $newQuantity');
            _isAddingToCart = false;
            notifyListeners();
            return true;
          } else {
            throw Exception(
              addToCartResponse.message ?? 'Failed to update cart',
            );
          }
        } else {
          // Quantity is 1, so remove from cart
          _cartItems.remove(serviceId);
          dev.log('Removed from cart: Service ID $serviceId');
          _isAddingToCart = false;
          notifyListeners();
          return true;
        }
      } catch (e) {
        dev.log('Error decrementing quantity: $e');
        _isAddingToCart = false;
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  double get totalAmount {
    double total = 0;
    _cartItems.forEach((serviceId, quantity) {
      final service = _serviceProviders.firstWhere(
        (sp) => sp.id == serviceId,
        orElse: () => ServiceData(),
      );
      total += (service.servicePrice ?? 0) * quantity;
    });
    return total;
  }

  int get cartItemCount {
    return _cartItems.values.fold(0, (sum, qty) => sum + qty);
  }

  Map<int, int> get cartItems => Map.from(_cartItems);
}
