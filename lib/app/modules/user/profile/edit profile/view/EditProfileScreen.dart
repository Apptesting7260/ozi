import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_bottom_shit.dart';
import '../../../../../shared/widgets/custom_image_path_helper.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../../view/profile_provider/profile_provider.dart';
import '../provider/EditProfileProvider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  void initState(BuildContext context) {
    final profileProvider = context.read<ProfileProvider>();
    profileProvider.fetchUserProfile();
  }
  @override
  Widget build(BuildContext context) {

    final provider = context.watch<EditProfileProvider>();

    return Scaffold(
          body: Column(
            children: [
              const CustomAppBar(title: "Edit Profile"),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      hBox(10),

                      /// PROFILE SECTION
                      _profileSection(provider, context),

                      hBox(30),

                      /// FIELDS
                      _inputFields(provider),

                      hBox(30),

                      CustomButton(
                        borderRadius: BorderRadius.circular(60),
                        text: provider.isUpdating ? "Updating..." : "Update Profile",
                        onPressed: provider.isUpdating ? null :
                             () => provider.updateProfile(context),
                        height: 54,
                      ),


                      hBox(30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }

  // ─────────────────── PROFILE SECTION ───────────────────
  Widget _profileSection(EditProfileProvider provider, context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              height: 110,
              width: 110,
              // padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 3),
              ),
              child: ClipOval(
                child: provider.pickedImage != null
                    ? Image.file(
                  File(provider.pickedImage!.path),
                  fit: BoxFit.cover,
                )
                    : CustomImage(
                  path: ImagePathHelper.getFullImageUrl(
                    provider.networkImage,
                    AppUrls.imageBaseUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// CAMERA BUTTON
            GestureDetector(
              onTap: () => _showPicker(context),
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        hBox(10),
        Text(
          "Change Photo",
          style: AppFontStyle.text_14_500(AppColors.primary),
        ),
      ],
    );
  }


  void _showPicker(BuildContext context) {
    final provider = Provider.of<EditProfileProvider>(context, listen: false);

    CustomBottomSheet.show(
      context: context,
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            hBox(20),

            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                provider.pickGallery();
              },
            ),

            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                provider.pickCamera();
              },
            ),

            hBox(10),
          ],
        ),
      ),
    );
  }

  Widget _inputFields(EditProfileProvider provider) {
    return Column(
      children: [
        CustomTextFormField(
          label: "First Name",
          hintText: "Alex",
          controller: provider.firstNameController,
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomImage(
              path: ImageConstants.userIcon,
              height: 14,
              width: 14,
            ),
          ),
        ),

        hBox(16),

        CustomTextFormField(
          label: "Last Name",
          hintText: "Johnson",
          controller: provider.lastNameController,
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomImage(
              path: ImageConstants.userIcon,
              height: 14,
              width: 14,
            ),
          ),
        ),

        hBox(16),

        CustomTextFormField(
          label: "Email Address",
          hintText: "yourname@gmail.com",
          controller: provider.emailController,
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomImage(
              path: ImageConstants.mail,
              height: 14,
              width: 14,
            ),
          ),
        ),
      ],
    );
  }
}