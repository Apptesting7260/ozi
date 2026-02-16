import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/utils/get_utils.dart';
import '../../../../data/models/all_services_model_vendor.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/response/api_response.dart';


// class MyServiceModel {
//   final String id;
//   final String title;
//   final String category;
//   final String duration;
//   final double price;
//   final String image;
//   final bool isActive;
//
//   MyServiceModel({
//     required this.id,
//     required this.title,
//     required this.category,
//     required this.duration,
//     required this.price,
//     required this.image,
//     required this.isActive,
//   });
// }

class VendorServicesProvider extends ChangeNotifier {
  // List<MyServiceModel> services = [
  //   MyServiceModel(
  //     id: "1",
  //     title: "Shirt Sleeve Shortening",
  //     category: "Tailor Services",
  //     duration: "3 hours",
  //     price: 84.13,
  //     image:
  //     "https://images.unsplash.com/photo-1520975916090-3105956dac38",
  //     isActive: true,
  //   ),
  //   MyServiceModel(
  //     id: "2",
  //     title: "Shirt Sleeve Shortening",
  //     category: "Tailor Services",
  //     duration: "3 hours",
  //     price: 84.13,
  //     image:
  //     "https://images.unsplash.com/photo-1520975916090-3105956dac38",
  //     isActive: false,
  //   ),
  // ];
  //
  // void deleteService(String id) {
  //   services.removeWhere((e) => e.id == id);
  //   notifyListeners();
  // }
  //
  // void editService(MyServiceModel service) {
  //   // later API / navigation
  // }

  final NetworkApiServices _apiService = NetworkApiServices();
  ScrollController scrollController = ScrollController();



  Timer? _debounce;



  bool? selectedStatus;
  String? selectedCategoryId;

  bool _isPaginationLoading = false;

  String? _search;
  String? _status;
  String? _categoryId;
  TextEditingController controller = TextEditingController();

  bool get isPaginationLoading => _isPaginationLoading;

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      getAllBookings();
    });
  }


  VendorServicesProvider() {
    getAllBookings();

    scrollController.addListener(() {
      final pagination = _homeModel.data?.pagination;

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          !_isPaginationLoading &&
          pagination?.hasMore == true) {
        getAllBookings(isLoadMore: true);
      }
    });

  }


  ApiResponse<VendorGetAllServicesModel> _homeModel = ApiResponse.loading();
  ApiResponse<VendorGetAllServicesModel> get homeModel => _homeModel;

  setHomeModel(ApiResponse<VendorGetAllServicesModel> value) {
    _homeModel = value;
    notifyListeners();
  }


  // Get All Bookings

  Future<void> getAllBookings({
    bool isLoadMore = false,
    String? status,
    String? categoryId,
  }) async {
    try {
      //  Handle Loading States
      if (isLoadMore) {
        if (_isPaginationLoading) return;
        _isPaginationLoading = true;
        notifyListeners();
      } else {
        setHomeModel(ApiResponse.loading());
      }

      //  Save Search + Filters
      _search = controller.text;
      _status = status;
      _categoryId = categoryId;

      //  Safe Pagination Logic
      int pageToLoad = isLoadMore
          ? (_homeModel.data?.pagination?.currentPage ?? 0) + 1
          : 1;

      //  Query Parameters
      Map<String, String> queryParams = {
        "search": _search ?? "",
        "page": pageToLoad.toString(),
        "limit": "10",
      };

      if (_status != null && _status!.isNotEmpty) {
        queryParams["status"] = _status!;
      }

      if (_categoryId != null && _categoryId!.isNotEmpty) {
        queryParams["category_id"] = _categoryId!;
      }

      String queryString =
      queryParams.entries.map((e) => "${e.key}=${e.value}").join("&");

      String url = "${AppUrls.getAllServicesVendor}?$queryString";

      selectedStatus = status == "active"
          ? true
          : status == "inactive"
          ? false
          : null;

      selectedCategoryId = categoryId;


      //  API Call
      final response = await _apiService.getApi(url);

      VendorGetAllServicesModel model =
      VendorGetAllServicesModel.fromJson(response);

      //  Handle Pagination vs Fresh Load
      if (isLoadMore) {
        _homeModel.data?.data?.addAll(model.data ?? []);
        _homeModel.data?.pagination = model.pagination;
      } else {
        _homeModel = ApiResponse.completed(model);
      }

      _isPaginationLoading = false;
      notifyListeners();
    } catch (e) {
      _isPaginationLoading = false;
      notifyListeners();
      setHomeModel(ApiResponse.error("Internal Server Error"));
    }
  }




  bool _deleteServiceLoading = false;
  bool get deleteServiceLoading => _deleteServiceLoading;
  updateDeleteServiceLoading(bool value) {
    _deleteServiceLoading = value;
    notifyListeners();
  }

  Future<void> deleteService(String serviceId) async {
    try {
      if (_deleteServiceLoading) return;
      updateDeleteServiceLoading(true);
      final response = await _apiService.deleteApi(
        {},
        AppUrls.deleteServiceVendor.replaceAll("{serviceid}", serviceId),
      );
      print(response);
      _homeModel.data?.data?.removeWhere((e) => e.id == serviceId);
      notifyListeners();
      updateDeleteServiceLoading(false);
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      updateDeleteServiceLoading(false);
    }
  }

  // bool _detailsLoading = false;
  // bool get detailsLoading => _detailsLoading;
  //
  // VendorGetAllServicesModel? _serviceDetails;
  // VendorGetAllServicesModel? get serviceDetails => _serviceDetails;
  //
  // final Repository _repository = Repository();
  //
  // Future<void> getServiceDetails(String serviceId) async {
  //   _detailsLoading = true;
  //   _serviceDetails = null;
  //   notifyListeners();
  //
  //   try {
  //     final response = await _repository.getservicedetailApi(serviceId);
  //     if (response.status == true) {
  //       _serviceDetails = response;
  //     } else {
  //       Get.showToast("Failed to fetch details", type: ToastType.error);
  //     }
  //   } catch (e) {
  //     Get.showToast(e.toString(), type: ToastType.error);
  //   } finally {
  //     _detailsLoading = false;
  //     notifyListeners();
  //   }
  // }
}
