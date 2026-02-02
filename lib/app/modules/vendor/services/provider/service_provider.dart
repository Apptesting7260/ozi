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

  VendorServicesProvider(){
    getAllBookings();
  }

  ApiResponse<VendorGetAllServicesModel> _homeModel = ApiResponse.loading();
  ApiResponse<VendorGetAllServicesModel> get homeModel => _homeModel;

  setHomeModel(ApiResponse<VendorGetAllServicesModel> value){
    _homeModel = value;
    notifyListeners();
  }


  Future<void> getAllBookings()async {
    try {
      setHomeModel(ApiResponse.loading());
      final response = await _apiService.getApi(AppUrls.getAllServicesVendor);
      print(response);
      setHomeModel(ApiResponse.completed(VendorGetAllServicesModel.fromJson(response)));
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      setHomeModel(ApiResponse.error('Internal Server Error'));
    }
  }




}
