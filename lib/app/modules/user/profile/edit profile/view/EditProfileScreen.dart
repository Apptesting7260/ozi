import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_bottom_shit.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/EditProfileProvider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileProvider(),
      builder: (context, child) {
        return Scaffold(
          body: Column(
            children: [
               CustomAppBar(title: "Edit Profile"),
              Expanded(
                child: SingleChildScrollView(
                  padding: REdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      hBox(10),

                      /// PROFILE SECTION
                      _profileSection(context),

                      hBox(30),

                      /// FIELDS
                      _inputFields(),

                      hBox(30),

                      CustomButton(
                        borderRadius: BorderRadius.circular(60),
                        text: "Update Profile",
                        onPressed: () {},
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
      },
    );
  }


  // ─────────────────── PROFILE SECTION ───────────────────

  Widget _profileSection(BuildContext context) {
    return Consumer<EditProfileProvider>(
      builder: (context, provider, _) {
        Widget displayImage;

        if (provider.pickedImage != null) {
          displayImage = Image.file(
            File(provider.pickedImage!.path),
            fit: BoxFit.cover,
          );
        } else {
          displayImage = Image.network(
            provider.networkImage,
            fit: BoxFit.cover,
          );
        }

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 110,
                  width: 110,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: ClipOval(child: displayImage),
                ),

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
                    child: Icon(
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
      },
    );
  }

  void _showPicker(BuildContext context) {
    // Get the provider BEFORE opening the bottom sheet
    final provider = Provider.of<EditProfileProvider>(context, listen: false);

    CustomBottomSheet.show(
      context: context,
      content: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            hBox(20), // Space for close button

            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                provider.pickGallery();
              },
            ),

            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text("Camera"),
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

  Widget _inputFields() {
    return Column(
      children: [
        CustomTextFormField(
          label: "First Name",
          hintText: "Alex",
          prefix: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
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
          prefix: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
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
          prefix: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
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