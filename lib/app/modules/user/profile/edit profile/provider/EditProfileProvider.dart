import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../../view/profile_provider/profile_provider.dart';

class EditProfileProvider extends ChangeNotifier {
  final bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  String networkImage = "";

  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final bool _isLoading = false;
  bool get isLoading => _isLoading;
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

      // Set network image
      if (userData.proImg != null && userData.proImg.toString().isNotEmpty) {
        networkImage = userData.proImg;
      }

      notifyListeners();
    }
  }


  Future<void> updateProfile(BuildContext context) async {
    try {
      //_isUpdating = true;
      notifyListeners();

      Map<String, String> fields = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
      };

      final response = await Repository().updateProfileApi(
        fields,
        selectedFile,
      );

    //  _isUpdating = false;
      notifyListeners();

      if (response["status"] == true) {
        /// ✅ REFRESH PROFILE DATA
        final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
        await profileProvider.fetchUserProfile();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully")),
        );

        Navigator.pop(context);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Update failed")),
        );
      }
    } catch (e) {
     // _isUpdating = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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