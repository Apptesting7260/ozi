


import '../../../../core/appExports/app_export.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
        
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("My Profile", style: AppFontStyle.text_24_600(AppColors.darkText, fontFamily: AppFontFamily.semiBold),),
            ),
        
            Expanded(
              child: SingleChildScrollView(
                padding: REdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
        
                    SizedBox(height: 10),
        
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
        
        
                          SizedBox(height: 14),
        
                          Text(
                            "Alex Johnson",
                            style: AppFontStyle.text_18_600(
                              AppColors.black,
                              fontFamily: AppFontFamily.bold,
                            ),
                          ),
        
                          SizedBox(height: 2),
        
                          Text(
                            "+1 (555) 123-4567",
                            style: AppFontStyle.text_14_400(AppColors.grey),
                          ),
                        ],
                      ),
                    ),
        
                    SizedBox(height: 26),
        
                    /// PROFILE OPTIONS LIST
                    _profileTile(
                      icon: ImageConstants.profile,
                      title: "Edit Profile",
                      onTap: () => Navigator.pushNamed(context, AppRoutes.editProfileScreen),
                    ),
        
                    _profileTile(
                      icon: ImageConstants.location,
                      title: "Saved Addresses",
                      onTap: () => Navigator.pushNamed(context, AppRoutes.savedAddressScreen),
                    ),
        
                    _profileTile(
                      icon: ImageConstants.card,
                      title: "Payment Methods",
                      onTap: () => Navigator.pushNamed(context, AppRoutes.paymentMethodsScreen),
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
                            color: AppColors.primary, // icon white
                            height: 22,
                            width: 22,
                          ),
                          wBox(8),
                          Text(
                            "Logout",
                            style: AppFontStyle.text_16_600(
                              AppColors.primary, // text white
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
    );
  }

  /// ------------------ REUSABLE TILE WIDGET ------------------

  Widget profileAvatarStatic({
    required String imageUrl,
    double size = 95,
  }) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(
              Icons.person,
              size: size * 0.5,
              color: AppColors.grey,
            ),
          ),
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
              height: 16,
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
                  style: AppFontStyle.text_18_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.bold,
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
                  isOutlined: true,
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
