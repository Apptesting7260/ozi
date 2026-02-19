import 'package:image_picker/image_picker.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../../view/profile_provider/profile_provider.dart';


// Croper Code

//import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:photo_manager/photo_manager.dart';
// import '../../../../../core/appExports/app_export.dart';
// import '../../../../../data/repository/repository.dart';
// import '../../view/profile_provider/profile_provider.dart';
//
//
// class EditProfileProvider extends ChangeNotifier {
//   bool _isUpdating = false;
//   bool get isUpdating => _isUpdating;
//
//   String networkImage = "";
//   final ImagePicker picker = ImagePicker();
//
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//
//   Future<int> _getAndroidSDKInt() async {
//     try {
//       final deviceInfo = await DeviceInfoPlugin().androidInfo;
//       return deviceInfo.version.sdkInt;
//     } catch (e) {
//       return 0; // default fallback
//     }
//   }
//
//   Future<File?> compressImage(File file, {int quality = 70}) async {
//     final filePath = file.absolute.path;
//
//     final result = await FlutterImageCompress.compressAndGetFile(
//       filePath,
//       filePath.replaceFirst(
//         RegExp(r'\.(jpg|jpeg|png|heic|webp)$', caseSensitive: false),
//         '_compressed.jpg',
//       ),
//       quality: quality,
//     );
//
//     if (result == null) return null;
//
//     return File(result.path);
//   }
//
//
//
//
//   File? profileImage;
// Future<void> pickAndCropSingleImage(BuildContext context) async {
//   bool hasPermission = false;
//
//   if (Platform.isAndroid) {
//     final sdkInt = await _getAndroidSDKInt();
//     print("Android SDK Int: $sdkInt");
//     if (sdkInt >= 33) {
//       if (await Permission.photos.request().isGranted) {
//         hasPermission = true;
//       }
//     } else {
//       if (await Permission.storage.request().isGranted) {
//         hasPermission = true;
//       }
//     }
//   } else if (Platform.isIOS) {
//     final result = await PhotoManager.requestPermissionExtend();
//     if (result.isAuth) {
//       hasPermission = true;
//     } else {
//       print("iOS: Gallery access denied");
//       PhotoManager.openSetting();
//       return;
//     }
//   }
//
//   if (!hasPermission) {
//     print("Gallery access denied");
//     return;
//   }
//
//   // // Pick image from gallery
//   final picker = ImagePicker();
//   // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//   // if (pickedFile == null) {
//   //   print("No image selected");
//   //   return;
//   // }
//   //
//   // // Crop the picked image
//   // final croppedFile = await ImageCropper().cropImage(
//   //   sourcePath: pickedFile.path,
//   //   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//   //   uiSettings: [
//   //     AndroidUiSettings(
//   //       toolbarTitle: 'Crop Image',
//   //       toolbarColor: navigatorKey.currentContext!.white,
//   //       toolbarWidgetColor: navigatorKey.currentContext!.black,
//   //       initAspectRatio: CropAspectRatioPreset.original,
//   //       lockAspectRatio: true,
//   //     ),
//   //     IOSUiSettings(title: 'Crop Image'),
//   //   ],
//   // );
//   //
//   // if (croppedFile != null) {
//   //   profileImage = File(croppedFile.path);
//   //   notifyListeners();
//   // }
//   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//   if (pickedFile == null) return;
//
//   try {
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: pickedFile.path,
//       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Image',
//           toolbarColor: AppColors.white,
//           toolbarWidgetColor: AppColors.black,
//           lockAspectRatio: true,
//         ),
//         IOSUiSettings(title: 'Crop Image'),
//       ],
//     );
//
//     if (croppedFile != null) {
//       File file = File(croppedFile.path);
//       File? compressed = await compressImage(file);
//       if (compressed != null) {
//         profileImage = compressed;
//         notifyListeners();
//       }
//     }
//   } catch (e) {
//     print("Cropper Crash: $e");
//   }
//
// }
//
//   File? get selectedFile =>
//       profileImage != null ? File(profileImage!.path) : null;
//   void populateProfileData(dynamic userData) {
//     if (userData != null) {
//       firstNameController.text = userData.firstName ?? '';
//       lastNameController.text = userData.lastName ?? '';
//       emailController.text = userData.email ?? '';
//
//       if (userData.proImg != null && userData.proImg.toString().isNotEmpty) {
//         networkImage = userData.proImg;
//       }
//       notifyListeners();
//     }
//   }
//
//   // -------------------- UPDATE PROFILE --------------------
//   Future<void> updateProfile(BuildContext context) async {
//     try {
//       _isUpdating = true;
//       notifyListeners();
//
//       Map<String, String> fields = {
//         "first_name": firstNameController.text.trim(),
//         "last_name": lastNameController.text.trim(),
//         "email": emailController.text.trim(),
//       };
//
//       // Call API
//       final response = await Repository().updateProfileApi(
//         fields,
//         selectedFile,
//       );
//
//       _isUpdating = false;
//       notifyListeners();
//
//       // VALIDATE RESPONSE PROPERLY
//       if (response.status == true) {
//         // Refresh profile data
//         final profileProvider = Provider.of<ProfileProvider>(
//           context,
//           listen: false,
//         );
//         await profileProvider.fetchUserProfile();
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(response.message ?? "Profile Updated")),
//         );
//
//         Navigator.pop(context); // <-- Navigate back to profile screen
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Profile Update Failed")));
//       }
//     } catch (e) {
//       _isUpdating = false;
//       notifyListeners();
//       Get.showToast(
//         e.toString() ?? 'Something went wrong',
//         type: ToastType.error,
//       );
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text("Error: $e")),
//       // );
//     }
//   }
//
//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     super.dispose();
//   }
// }

class EditProfileProvider extends ChangeNotifier {
  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  String networkImage = "";
  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future pickGallery() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      pickedImage = img;
      notifyListeners();
    }
  }

  Future pickCamera() async {
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      pickedImage = img;
      notifyListeners();
    }
  }

  File? get selectedFile =>
      pickedImage != null ? File(pickedImage!.path) : null;
  void populateProfileData(dynamic userData) {
    if (userData != null) {
      firstNameController.text = userData.firstName ?? '';
      lastNameController.text = userData.lastName ?? '';
      emailController.text = userData.email ?? '';

      if (userData.proImg != null && userData.proImg.toString().isNotEmpty) {
        networkImage = userData.proImg;
      }
      notifyListeners();
    }
  }

  // -------------------- UPDATE PROFILE --------------------
  Future<void> updateProfile(BuildContext context) async {
    try {
      _isUpdating = true;
      notifyListeners();

      Map<String, String> fields = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
      };

      // Call API
      final response = await Repository().updateProfileApi(
        fields,
        selectedFile,
      );

      _isUpdating = false;
      notifyListeners();

      // VALIDATE RESPONSE PROPERLY
      if (response.status == true) {
        // Refresh profile data
        final profileProvider = Provider.of<ProfileProvider>(
          context,
          listen: false,
        );
        await profileProvider.fetchUserProfile();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Profile Updated")),
        );

        Navigator.pop(context); // <-- Navigate back to profile screen
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile Update Failed")));
      }
    } catch (e) {
      _isUpdating = false;
      notifyListeners();
      Get.showToast(
        e.toString() ?? 'Something went wrong',
        type: ToastType.error,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Error: $e")),
      // );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
