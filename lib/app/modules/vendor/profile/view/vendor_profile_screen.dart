import '../../../../core/appExports/app_export.dart';
import '../../../../routes/app_routes.dart';

class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Profile", style: AppFontStyle.text_24_600(AppColors.darkText,
                  fontFamily: AppFontFamily.semiBold),),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      hBox(10),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            profileAvatarStatic(
                              imageUrl: "https://images.unsplash.com/photo-1527980965255-d3b416303d12",
                              size: 90,
                            ),
                            hBox(14),

                            Text(
                              "Alex Johnson",
                              style: AppFontStyle.text_18_600(
                                AppColors.black,
                                fontFamily: AppFontFamily.bold,
                              ),
                            ),
                            hBox(2),

                            Text(
                              "+1 (555) 123-4567",
                              style: AppFontStyle.text_14_400(AppColors.grey),
                            ),
                          ],
                        ),
                      ),

                       hBox(26),

                      _profileTile(
                        icon: ImageConstants.profile,
                        title: "Edit Profile",
                        onTap: () => Navigator.pushNamed(context, AppRoutes.editProfileScreen),
                      ),

                      _profileTile(
                        icon: ImageConstants.calendor,
                        title: "Availability",
                        onTap: () => Navigator.pushNamed(context, AppRoutes.editProfileScreen),
                      ),

                      _profileTile(
                        icon: ImageConstants.document,
                        title: "Documents",
                        onTap: () => Navigator.pushNamed(context, AppRoutes.savedAddressScreen),
                      ),

                      _profileTile(
                        icon: ImageConstants.help,
                        title: "Help & Support",
                        onTap: () => Navigator.pushNamed(context, AppRoutes.helpSupportScreen),
                      ),

                      _profileTile(
                        icon: ImageConstants.setting,
                        title: "Settings",
                        onTap: () => Navigator.pushNamed(context, AppRoutes.settingsScreen),
                      ),

                      hBox(10),

                      CustomButton(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primary.withValues(alpha: 0.30),
                        onPressed: () {
                          showDeleteDialog(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImage(
                              path: ImageConstants.logout,
                              color: AppColors.primary,
                              height: 22,
                              width: 22,
                            ),

                            wBox(8),

                            Text(
                              "Logout",
                              style: AppFontStyle.text_16_600(
                                AppColors.primary,
                                fontFamily: AppFontFamily.semiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  hBox(30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget profileAvatarStatic({
    required String imageUrl,
    double size = 95,
  }) {
    return  Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 4,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: CustomImage(
          path: "https://i.pravatar.cc/150?img=5",
          height: size,
          width: size,

        ),
      ),
    );
  }


  Widget _profileTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        margin: EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.dividerColor),
        ),
        child: Row(
          children: [

            SizedBox(
              height: 22,
              width: 22,
              // decoration: BoxDecoration(
              //   color: AppColors.lightGreen20,
              //   borderRadius: BorderRadius.circular(8),
              // ),
              child: CustomImage(path: icon, color: AppColors.primary,),
            ),

            SizedBox(width: 14),

            /// TITLE
            Expanded(
              child: Text(
                title,
                style: AppFontStyle.text_15_500(AppColors.black),
              ),
            ),

            /// RIGHT ARROW
            CustomImage(
              path: ImageConstants.rightBack,
              color: AppColors.grey,
              height: 12,
              width: 6,
            )
          ],
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: AppColors.white,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Logout",
                  style: AppFontStyle.text_20_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.semiBold,
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  "Are you sure you want to logout\nyour account?",
                  style: AppFontStyle.text_14_400(AppColors.grey),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 22),

                CustomButton(
                  text: "Yes, Logout",
                  borderRadius: BorderRadius.circular(30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                SizedBox(height: 12),

                CustomButton(
                  text: "No, Stay Logged In",
                  textStyle: AppFontStyle.text_14_500(AppColors.darkText, fontFamily: AppFontFamily.semiBold),
                  isOutlined: true,
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
