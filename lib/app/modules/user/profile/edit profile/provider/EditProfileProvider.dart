import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../data/repository/repository.dart';

class EditProfileProvider extends ChangeNotifier {
  final _repository = Repository();

  String networkImage =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";

  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();

  // Text controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Pick from gallery
  Future pickGallery() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      pickedImage = img;
      notifyListeners();
    }
  }

  // Pick from camera
  Future pickCamera() async {
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      pickedImage = img;
      notifyListeners();
    }
  }

  File? get selectedFile =>
      pickedImage != null ? File(pickedImage!.path) : null;

  // Fetch user profile and populate fields
  Future<void> fetchAndPopulateProfile() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      dynamic response = await _repository.getProfileApi();

      if (response['status'] == true && response['data'] != null) {
        final data = response['data'];

        // Populate controllers
        firstNameController.text = data['first_name'] ?? '';
        lastNameController.text = data['last_name'] ?? '';
        emailController.text = data['email'] ?? '';

        // Set network image
        if (data['pro_img'] != null && data['pro_img'].toString().isNotEmpty) {
          networkImage = data['pro_img'];
        }
      } else {
        _errorMessage = response['message'] ?? 'Failed to fetch profile';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      print('Error fetching profile: $_errorMessage');
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