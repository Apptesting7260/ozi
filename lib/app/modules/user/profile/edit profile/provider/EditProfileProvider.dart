import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileProvider extends ChangeNotifier {
  String networkImage =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";

  XFile? pickedImage;

  final ImagePicker picker = ImagePicker();

  /// pick from gallery
  Future pickGallery() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      pickedImage = img;
      notifyListeners();
    }
  }

  /// pick from camera
  Future pickCamera() async {
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      pickedImage = img;
      notifyListeners();
    }
  }

  File? get selectedFile =>
      pickedImage != null ? File(pickedImage!.path) : null;
}
