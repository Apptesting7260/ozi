import 'package:image_picker/image_picker.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../../view/profile_provider/profile_provider.dart';

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
      _cropImage(img.path);
    }
  }

  Future pickCamera() async {
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      _cropImage(img.path);
    }
  }

  Future<void> _cropImage(String filePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Photo',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Edit Photo', aspectRatioLockEnabled: true),
      ],
    );

    if (croppedFile != null) {
      pickedImage = XFile(croppedFile.path);
      notifyListeners();
    }
  }

  File? get selectedFile =>
      pickedImage != null ? File(pickedImage!.path) : null;

  String _originalVerifiedEmail = '';

  void populateProfileData(dynamic userData) {
    if (userData != null) {
      firstNameController.text = userData.firstName ?? '';
      lastNameController.text = userData.lastName ?? '';
      emailController.text = userData.email ?? '';

      // Store the original email as the verified email
      _originalVerifiedEmail = (userData.email ?? '').toString().trim();
      _isEmailVerified = _originalVerifiedEmail.isNotEmpty;

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
        final profileProvider = Provider.of<ProfileProvider>(
          context,
          listen: false,
        );
        await profileProvider.fetchUserProfile();

        Get.showToast(
          response.message ?? "Profile Updated",
          type: ToastType.success,
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response.message ?? "Profile Updated")),
        // );

        Navigator.pop(context);
      } else {
        Get.showToast("Profile Update Failed", type: ToastType.error);
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text("Profile Update Failed")));
      }
    } catch (e) {
      _isUpdating = false;
      notifyListeners();
      Get.showToast(e.toString(), type: ToastType.error);
    }
  }

  // Email Verification

  bool _isEmailValid = false;
  bool get isEmailValid => _isEmailValid;

  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  bool _isloading = false;
  bool get isloading => _isloading;

  bool _otpLoading = false;
  bool get otpLoading => _otpLoading;

  updateISLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  Future<dynamic> emailSendOtpApi(Map<String, dynamic> data) async {
    try {
      updateISLoading(true);
      final response = await Repository().verifyUpdateEmailApi(data);
      updateISLoading(false);
      return response;
    } catch (e) {
      updateISLoading(false);
      rethrow;
    }
  }

  Future<dynamic> verifyEmailApi(Map<String, dynamic> data) async {
    try {
      _otpLoading = true;
      notifyListeners();
      final response = await Repository().verifyEditProfileEmailApi(data);
      _otpLoading = false;
      if (response['status'] == true ||
          response['status'] == 200 ||
          response['message']?.toString().toLowerCase().contains('success') ==
              true) {
        _isEmailVerified = true;
        // Update the original verified email to the newly verified one
        _originalVerifiedEmail = emailController.text.trim();
      }
      notifyListeners();
      return response;
    } catch (e) {
      _otpLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void validateEmail(String val) {
    _isEmailValid = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(val.trim());
    // If user typed back the original verified email, show verified icon
    // Otherwise, reset verification
    _isEmailVerified = val.trim() == _originalVerifiedEmail;
    notifyListeners();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
