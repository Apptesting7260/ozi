import 'package:ozi/app/modules/user/profile/view/profile_provider/profile_provider.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const ProfileScreenView(),
    );
  }
}

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final logoutProvider = context.watch<ProfileProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "My Profile",
                style: AppFontStyle.text_24_600(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: REdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    hBox(10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
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
                        if (!logoutProvider.isLoading) {
                          showDeleteDialog(context, logoutProvider);
                        }
                      },
                      child: logoutProvider.isLoading
                          ?  SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      )
                          : Row(
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
    );
  }

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
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.dividerColor),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: Center(
                child: CustomImage(
                  path: icon,
                  color: AppColors.primary,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            wBox(14),
            Expanded(
              child: Text(
                title,
                style: AppFontStyle.text_15_500(AppColors.black),
              ),
            ),
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

  Future<void> showDeleteDialog(BuildContext context, ProfileProvider provider) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
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
                const SizedBox(height: 12),
                Text(
                  "Are you sure you want to logout\nyour account?",
                  style: AppFontStyle.text_14_400(AppColors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                CustomButton(
                  text: "Yes, Logout",
                  borderRadius: BorderRadius.circular(30),
                  onPressed: () {
                    provider.logout(context);
                    showCustomToast(context, "Logged out successfully");
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: "No, Stay Logged In",
                  isOutlined: true,
                  borderRadius: BorderRadius.circular(30),
                  onPressed: () {
                    Navigator.pop(dialogContext);
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