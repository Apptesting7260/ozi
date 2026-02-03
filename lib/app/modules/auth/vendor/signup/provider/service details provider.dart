import 'package:flutter/material.dart';
import 'dart:io';

import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/utils/get_utils.dart';
import '../../../../../data/models/all_services_model_vendor.dart';
import '../../../../../data/models/category_dropdown_model.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/storage/user_preference.dart';

class ServiceDetailsProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  ServiceDetailsProvider(VendorGetAllServicesModelData? service){
     getCategoriesData(service);
  }

  File? pickedImage;

  CategoryDropDownData? category;
  Subcategories? subCategory;
  String? durationUnit;
  String? durationValue;
  TextEditingController serviceName  = TextEditingController();
  TextEditingController description  = TextEditingController();
  TextEditingController priceAmount  = TextEditingController();


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

  // void setPrice(String? val) {
  //   priceAmount = val;
  //   notifyListeners();
  // }

  // void setName(String? val) {
  //   serviceName = val;
  //   notifyListeners();
  // }

  // void setDescription(String? val) {
  //   description = val;
  //   notifyListeners();
  // }

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

  Future<void> getCategoriesData(VendorGetAllServicesModelData? service)async {
    try {
      setCategory(null);
      final response = await _apiService.getApi(AppUrls.vendorGetCategoryData);
      print(response);
      updateCategories(CategoryDropDown.fromJson(response));
      if(service!=null){
        serviceName.text = service.serviceName??'';
        description.text = service.description??'';
        priceAmount.text = service.servicePrice??'';
        setCategory(categories?.data?.firstWhere((e)=>e.id==service.category?.id));
        setSubCategory(category?.subcategories?.firstWhere((e)=>e.id==service.subcategory?.id));
        notifyListeners();
      }
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
        "service_name":serviceName.text,
        "category_id":category?.id??'',
        "subcategory_id":subCategory?.id??'',
        "duration_value":durationValue??'',
        "duration_type":durationUnit??'',
        "service_price":priceAmount.text,
        "description":description.text
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
