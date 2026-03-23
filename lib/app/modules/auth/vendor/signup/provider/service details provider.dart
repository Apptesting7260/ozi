import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/models/all_services_model_vendor.dart';
import '../../../../../data/models/category_dropdown_model.dart';
import '../../../../../data/network/network_api_services.dart';

class ServiceDetailsProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();
  VendorGetAllServicesModelData? serviceForEdit;
  final ImagePicker picker = ImagePicker();

  ServiceDetailsProvider(VendorGetAllServicesModelData? service) {
    serviceForEdit = service;
    if (service != null) {
      status = service.status == 'active' ? 'Active' : 'Inactive';
    }
    getCategoriesData(service);
  }

  String? imageError;

  bool validateImage() {
    if (profileImage == null &&
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

  String? durationUnit = "minutes";
  String? durationValue = "10";

  List<String> get durationList {
    if (durationUnit == "hours") {
      return List.generate(12, (index) => "${index + 1}");
    } else {
      return ["10", "20", "30", "40", "50", "60"];
    }
  }

  void setDurationUnit(String? value) {
    if (durationUnit == value) return;

    durationUnit = value;

    // preserve value if exists in new list
    if (!durationList.contains(durationValue)) {
      durationValue = durationList.first;
    }

    notifyListeners();
  }


  void setDurationValue(String? value) {
    durationValue = value;
    notifyListeners();
  }



  // File? pickedImage;

  CategoryDropDownData? category;
  Subcategories? subCategory;
  TextEditingController serviceName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController priceAmount = TextEditingController();
  String status = 'Active';

  Future<int> _getAndroidSDKInt() async {
    try {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      return deviceInfo.version.sdkInt;
    } catch (e) {
      return 0; // default fallback
    }
  }

  Future<File?> compressImage(File file, {int quality = 70}) async {
    final filePath = file.absolute.path;

    final result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      filePath.replaceFirst(
        RegExp(r'\.(jpg|jpeg|png|heic|webp)$', caseSensitive: false),
        '_compressed.jpg',
      ),
      quality: quality,
    );

    if (result == null) return null;

    return File(result.path);
  }




  File? profileImage;
  Future<void> pickAndCropSingleImage(BuildContext context) async {
    bool hasPermission = false;

    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSDKInt();
      if (kDebugMode) {
        print("Android SDK Int: $sdkInt");
      }
      if (sdkInt >= 33) {
        if (await Permission.photos.request().isGranted) {
          hasPermission = true;
        }
      } else {
        if (await Permission.storage.request().isGranted) {
          hasPermission = true;
        }
      }
    } else if (Platform.isIOS) {
      final result = await PhotoManager.requestPermissionExtend();
      if (result.isAuth) {
        hasPermission = true;
      } else {
        if (kDebugMode) {
          print("iOS: Gallery access denied");
        }
        PhotoManager.openSetting();
        return;
      }
    }

    if (!hasPermission) {
      if (kDebugMode) {
        print("Gallery access denied");
      }
      return;
    }

    // // Pick image from gallery
    final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile == null) {
    //   print("No image selected");
    //   return;
    // }
    //
    // // Crop the picked image
    // final croppedFile = await ImageCropper().cropImage(
    //   sourcePath: pickedFile.path,
    //   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    //   uiSettings: [
    //     AndroidUiSettings(
    //       toolbarTitle: 'Crop Image',
    //       toolbarColor: navigatorKey.currentContext!.white,
    //       toolbarWidgetColor: navigatorKey.currentContext!.black,
    //       initAspectRatio: CropAspectRatioPreset.original,
    //       lockAspectRatio: true,
    //     ),
    //     IOSUiSettings(title: 'Crop Image'),
    //   ],
    // );
    //
    // if (croppedFile != null) {
    //   profileImage = File(croppedFile.path);
    //   notifyListeners();
    // }
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.white,
            toolbarWidgetColor: AppColors.black,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Crop Image'),
        ],
      );

      if (croppedFile != null) {
        File file = File(croppedFile.path);
        File? compressed = await compressImage(file);
        if (compressed != null) {
          profileImage = compressed;
          notifyListeners();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Cropper Crash: $e");
      }
    }

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
      profileImage != null &&
          category != null;

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
      if (kDebugMode) {
        print(response);
      }
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
    if (profileImage != null) {
      files["service_image"] = profileImage?.path ?? '';
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
      if (kDebugMode) {
        print(response);
      }
      if (response['status'] == true) {
        Navigator.pop(navigatorKey.currentContext!, true);
      }

      updateAddLoading(false);
    } catch (e) {
      updateAddLoading(false);
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }
}


