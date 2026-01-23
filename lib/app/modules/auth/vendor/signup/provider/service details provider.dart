import 'package:flutter/material.dart';
import 'dart:io';

import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/utils/get_utils.dart';
import '../../../../../data/models/category_dropdown_model.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/storage/user_preference.dart';

class ServiceDetailsProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  ServiceDetailsProvider(){
    getCategoriesData();
  }

  File? pickedImage;

  CategoryDropDownData? category;
  Subcategories? subCategory;
  String? durationUnit;
  String? durationValue;
  String? serviceName;
  String? description;
  String? priceAmount;

  void setImage(File file) {
    pickedImage = file;
    notifyListeners();
  }

  void setCategory(CategoryDropDownData? val) {
    category = val;
    setSubCategory(null);
    notifyListeners();
  }

  void setSubCategory(Subcategories? val) {
    subCategory = val;
    notifyListeners();
  }

  void setDurationUnit(String? val) {
    durationUnit = val;
    notifyListeners();
  }

  void setDurationValue(String? val) {
    durationValue = val;
    notifyListeners();
  }

  void setPrice(String? val) {
    priceAmount = val;
    notifyListeners();
  }

  void setName(String? val) {
    serviceName = val;
    notifyListeners();
  }

  void setDescription(String? val) {
    description = val;
    notifyListeners();
  }

  bool get enableContinue =>
      pickedImage != null &&
          serviceName != null &&
          category != null &&
          priceAmount != null;

  //CategoryDropDown

  CategoryDropDown? _categories;
  CategoryDropDown? get categories => _categories;
  updateCategories(CategoryDropDown? value){
    _categories = value;
    notifyListeners();
  }

  Future<void> getCategoriesData()async {
    try {
      setCategory(null);
      final response = await _apiService.getApi(AppUrls.vendorGetCategoryData);
      print(response);
      updateCategories(CategoryDropDown.fromJson(response));
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }


  bool _addLoading = false;
  bool get addLoading => _addLoading;
  updateAddLoading(bool value){
    _addLoading = value;
    notifyListeners();
  }

  Future<void> addNewService()async {
    if(_addLoading) return;
    updateAddLoading(true);
    try {
      final response = await _apiService.postApiMultiPart(AppUrls.storeVendorService,
          {
        "service_name":serviceName??'',
        "category_id":category?.id??'',
        "subcategory_id":subCategory?.id??'',
        "duration_value":durationValue??'',
        "duration_type":"hours",//durationUnit??'',
        "service_price":priceAmount??'',
        "description":description??''
      },{
      "service_image":pickedImage?.path??'',
      });
      print(response);
      if(response['status']==true){
        Navigator.pop(navigatorKey.currentContext!);
      }
      updateAddLoading(false);
    } catch (e) {
      updateAddLoading(false);
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }




}
