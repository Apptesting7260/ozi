// import 'package:device_info_plus/device_info_plus.dart';
//
// import 'package:g_clout_media/core/appExports/app_export.dart' hide User;
//
// import 'package:g_clout_media/presentation/dashboard/presentation/profile/provider/profile_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../../../../../Models/chat_models/chat_files_presigned_model.dart';
// import '../../../../../../Models/presigned_response_model.dart';
// import '../../../../../../Models/profile_data_model.dart';
//
//
//
//
//
// class CreateGroupProvider with ChangeNotifier {
//
//   CreateGroupProvider(){
//     getUserId();
//   }
//
//
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//
//
//   String? userId;
//
//   Future<void> getUserId() async {
//     userId = await UserPreference.returnUserId() ?? '';
//   }
//
//
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController bioController = TextEditingController();
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
//
//   File? profileImage;
//   Future<void> pickAndCropSingleImage(BuildContext context) async {
//
//     bool hasPermission = false;
//
//     if (Platform.isAndroid) {
//
//       final sdkInt = await _getAndroidSDKInt();
//       print("Android SDK Int: $sdkInt");
//       if (sdkInt >= 33) {
//         if (await Permission.photos.request().isGranted) {
//           hasPermission = true;
//         }
//       } else {
//         if (await Permission.storage.request().isGranted) {
//           hasPermission = true;
//         }
//       }
//     } else if (Platform.isIOS) {
//       final result = await PhotoManager.requestPermissionExtend();
//       if (result.isAuth ) {
//         hasPermission = true;
//       } else {
//         print("iOS: Gallery access denied");
//         PhotoManager.openSetting();
//         return;
//       }
//     }
//
//     if (!hasPermission) {
//       print("Gallery access denied");
//       return;
//     }
//
//     // Pick image from gallery
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile == null) {
//       print("No image selected");
//       return;
//     }
//
//     // Crop the picked image
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: pickedFile.path,
//       aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Image',
//           toolbarColor: navigatorKey.currentContext!.white,
//           toolbarWidgetColor: navigatorKey.currentContext!.black,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: true,
//         ),
//         IOSUiSettings(title: 'Crop Image'),
//       ],
//     );
//
//     if (croppedFile != null) {
//       profileImage = File(croppedFile.path);
//       notifyListeners();
//     }
//   }
//
//
//
//
//
//   Future<void> pickImageFromCamera() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.camera,
//     );
//
//     if (pickedFile != null) {
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedFile.path,
//         aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: navigatorKey.currentContext!.white,
//             toolbarWidgetColor: navigatorKey.currentContext!.black,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: true,
//           ),
//           IOSUiSettings(title: 'Crop Image'),
//         ],
//       );
//
//       if (croppedFile != null) {
//         profileImage = File(croppedFile.path);
//         notifyListeners();
//       }
//     }
//   }
//
//   Repository _repo = Repository();
//
//
//   ChatFilePresignedUrlsModel? preSignedUrl;
//
//   Future<void> getPresignedUrl()async {
//     try{
//       ChatFilePresignedUrlsModel? value = await _repo.getPresignedUrlForListFilesChat('image', 1,null);
//       preSignedUrl = value;
//     }catch(e){
//       Get.showToast(e.toString(), type: ToastType.error);
//     }
//   }
//
//   Future<void> uploadImage(String url,String filePath) async {
//     final success = await _repo.uploadFile(
//       filePath: filePath,
//       uploadUrl: url,
//       fileType: UploadFileType.image,
//     );
//
//     if (success) {
//       print('Upload Image success');
//     } else {
//       print('Upload Image failed');
//     }
//   }
//
//
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   void updateLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   Future<void> updateProfile(BuildContext context,List<String> members) async{
//
//     updateLoading(true);
//     await getPresignedUrl();
//     if(profileImage!=null){
//       await uploadImage(preSignedUrl?.uploadUrls?[0]??'',profileImage!.path);
//     }
//
//     SocketController socket = navigatorKey.currentContext!.read();
//     socket.sendMessage(AppUrls.createGroupEvent, {
//       "groupName": nameController.text,//groupName,description,groupImage,createdBy,members
//       "description": bioController.text,
//       "groupImage": preSignedUrl?.publicUrls?[0]??'',
//       "createdBy":userId,
//       "members": members,
//     });
//
//     socket.listenToEvent(
//       AppUrls.createGroupEvent,
//           (p0) {
//         socket.off(AppUrls.createGroupEvent);
//         if (p0 is String) {
//           final data = jsonDecode(p0);
//           // use data['key']
//           if (kDebugMode) {
//             print("data string is $data");
//           }
//         } else if (p0 is Map) {
//           final data = p0 as Map<String, dynamic>;
//           if(data['status']==true){
//             Navigator.pop(context);
//           }
//           updateLoading(false);
//           if (kDebugMode) {
//             print("data Map is $data");
//           }
//         }
//       },
//     );
//
//     // _repo.updateProfileApi({
//     //   "fullName":nameController.text,
//     //   "userName":userNameController.text,
//     //   "bio":bioController.text,
//     //   "location":locationController.text,
//     //   "coverphoto":coverImageFile!=null?preSignedUrl?.coverImageUrl??coverImage??'':coverImage??'',
//     //   "website":websiteController.text,
//     //   "profile":profileImage!=null?preSignedUrl?.imageUrl?? profileImageUrl??'': profileImageUrl??'',
//     // }).then((value) => {
//     //   if(context.mounted && value['status'] == true){
//     //     context.read<ProfileProvider>().getProfileData(),
//     //     Navigator.pop(context)
//     //   },
//     //   Get.showToast(value['message']?.toString()??'Update Successfully', type: ToastType.success),
//     //   updateLoading(false)
//     // }).onError((error, stackTrace) => {
//     //   if(error.toString().contains("user name is already exists.")){
//     //     setUserNameFieldError(error.toString()),
//     //     _scrollToWidgetByKey(userNameKey)
//     //   }else{
//     //     Get.showToast(error.toString(), type: ToastType.error),
//     //   },
//     //   Get.consoleLog(error.toString(), "error while UPDATE PROFILE"),
//     //   updateLoading(false),
//     // },
//     // );
//   }
//
//
//
//
//
// }