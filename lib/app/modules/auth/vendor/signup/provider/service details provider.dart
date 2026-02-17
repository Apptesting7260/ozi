import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/utils/get_utils.dart';
import '../../../../../data/models/all_services_model_vendor.dart';
import '../../../../../data/models/category_dropdown_model.dart';
import '../../../../../data/network/network_api_services.dart';

class ServiceDetailsProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();
  VendorGetAllServicesModelData? serviceForEdit;

  ServiceDetailsProvider(VendorGetAllServicesModelData? service) {
    serviceForEdit = service;
    if (service != null) {
      status = service.status == 'active' ? 'Active' : 'Inactive';
    }
    getCategoriesData(service);
  }

  String? imageError;

  bool validateImage() {
    if (pickedImage == null &&
        serviceForEdit?.serviceImage == null) {
      imageError = "Please upload service image";
      notifyListeners();
      return false;
    }

    imageError = null;
    notifyListeners();
    return true;
  }

  // timer

  String? durationUnit = "minutes"; // default
  String? durationValue;

  List<String> get durationList {
    if (durationUnit == "hours") {
      return List.generate(12, (index) => "${index + 1}");
    } else {
      return ["10", "20", "30", "40", "50", "60"];
    }
  }

  void setDurationUnit(String? value) {
    durationUnit = value;

    if (value == "hours") {
      durationValue = "1";
    } else {
      durationValue = "10";
    }

    notifyListeners();
  }


  void setDurationValue(String? value) {
    durationValue = value;
    notifyListeners();
  }



  File? pickedImage;

  CategoryDropDownData? category;
  Subcategories? subCategory;
  TextEditingController serviceName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController priceAmount = TextEditingController();
  String status = 'Active';

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

  // void setDurationUnit(String? val) {
  //   durationUnit = val;
  //   notifyListeners();
  // }
  //
  // void setDurationValue(String? val) {
  //   durationValue = val;
  //   notifyListeners();
  // }

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
  updateCategories(CategoryDropDown? value) {
    _categories = value;
    notifyListeners();
  }

  Future<void> getCategoriesData(VendorGetAllServicesModelData? service) async {
    try {
      setCategory(null);
      final response = await _apiService.getApi(AppUrls.vendorGetCategoryData);
      print(response);
      updateCategories(CategoryDropDown.fromJson(response));
      if (service != null) {
        serviceName.text = service.serviceName ?? '';
        description.text = service.description ?? '';
        priceAmount.text = service.servicePrice ?? '';
        setCategory(
          categories?.data?.firstWhere((e) => e.id == service.category?.id),
        );
        setSubCategory(
          category?.subcategories?.firstWhere(
            (e) => e.id == service.subcategory?.id,
          ),
        );
        setDurationUnit(service.durationType);
        setDurationValue(service.durationValue);
        notifyListeners();
      }
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }

  bool _addLoading = false;
  bool get addLoading => _addLoading;
  updateAddLoading(bool value) {
    _addLoading = value;
    notifyListeners();
  }

  Future<void> addNewService() async {
    if (_addLoading) return;
    updateAddLoading(true);
    Map<String, String> data = {
      "service_name": serviceName.text,
      "category_id": category?.id ?? '',
      "subcategory_id": subCategory?.id ?? '',
      "duration_value": durationValue ?? '',
      "duration_type": durationUnit ?? '',
      "service_price": priceAmount.text,
      "description": description.text,
      "status": status.toLowerCase(),
    };
    Map<String, dynamic> files = {};
    if (pickedImage != null) {
      files["service_image"] = pickedImage?.path ?? '';
    }
    if (serviceForEdit != null) {
      data['service_id'] = serviceForEdit?.id ?? '';
    }
    try {
      final response = await _apiService.postApiMultiPart(
        AppUrls.storeVendorService,
        data,
        files,
      );
      print(response);
      if (response['status'] == true) {
        Navigator.pop(navigatorKey.currentContext!);
      }
      updateAddLoading(false);
    } catch (e) {
      updateAddLoading(false);
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }
}
