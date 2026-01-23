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
        final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
        await profileProvider.fetchUserProfile();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Profile Updated")),
        );

        Navigator.pop(context);   // <-- Navigate back to profile screen

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile Update Failed")),
        );
      }

    } catch (e) {
      _isUpdating = false;
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
