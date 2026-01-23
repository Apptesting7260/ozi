import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/data/storage/user_preference.dart';

import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/response/api_response.dart';
import '../../../../vendor/services/service_details/view/service_details_screen.dart';
import '../model/get_all_categories.dart';
import '../view/set_availability.dart';

class ServiceCategoryProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  ServiceCategoryProvider(){
    getAllCategorites();
  }

  // final categories = [
  //   "Tailor Services",
  //   "Entertainment & Event",
  //   "Towing Services",
  //   "Cleaning",
  //   "Handy Works",
  //   "Food",
  //   "Engineering",
  //   "Tutoring",
  //   "Painting",
  // ];


  final List<String> _selected = [];

  List<String> get selected => _selected;

  void toggleCategory(String category) {
    if (_selected.contains(category)) {
      _selected.remove(category);
    } else {
      _selected.add(category);
    }
    notifyListeners();
  }


  ApiResponse<GetAllCategoriesModel> _categoriesModel = ApiResponse.loading();
  ApiResponse<GetAllCategoriesModel> get categoriesModel => _categoriesModel;

  setCategoryModel(ApiResponse<GetAllCategoriesModel> value){
    _categoriesModel = value;
    notifyListeners();
  }

  // GetAllCategoriesModel? _categoriesModel;
  // GetAllCategoriesModel? get categoriesModel => _categoriesModel;
  // updateCategoryModel(GetAllCategoriesModel? value){
  //   _categoriesModel = value;
  //   notifyListeners();
  // }

  Future<void> getAllCategorites()async {
    // updateDataLoading(true);
    print('getting categories');
    setCategoryModel(ApiResponse.loading());
    try {
      final response = await _apiService.getApiWithoutToken(AppUrls.getAllCategories,);
      print(response);//data['api_token'],data['role']
      // updateCategoryModel(GetAllCategoriesModel.fromJson(response));
      setCategoryModel(ApiResponse.completed(GetAllCategoriesModel.fromJson(response)));
      // loginWithSaveTokenRedirection(response['data']['user_role']?.toString(),response['data']['api_token']?.toString());
      // ChooseRoleModel.fromJson(response);
    } catch (e) {
      setCategoryModel(ApiResponse.error('Internal Server Error'));
    }

  }

  bool _submitLoading = false;
  bool get submitLoading => _submitLoading;
  updateSubmitLoading(bool value){
    _submitLoading = value;
    notifyListeners();
  }

  Future<void> saveCategorites()async {
    updateSubmitLoading(true);
    try {
      Map<String,String> fields = {};
      _selected.forEach((e){
        fields.addAll({
          "categories[]":e
        });
      });
      final response = await _apiService.postApiMultiPart(AppUrls.saveCategoryForVendor,fields,{});
      print(response);
      updateSubmitLoading(false);
      // Navigator.push(
      //   navigatorKey.currentContext!,
      //   MaterialPageRoute(
      //     builder: (_) => ServiceDetailsScreen(),
      //   ),
      // );
      await UserPreference.saveStep('2');
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => SetAvailabilityScreen(),
        ),
      );
    } catch (e) {
      updateSubmitLoading(false);
      showCustomToast(navigatorKey.currentContext!, e.toString());
    }

  }


  bool isSelected(String category) => _selected.contains(category);
}
