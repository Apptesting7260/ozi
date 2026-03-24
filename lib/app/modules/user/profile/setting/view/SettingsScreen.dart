import 'package:ozi/app/modules/user/profile/setting/provider/settingprovider.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_toggle_switch.dart';
import '../../common screen/provider/comman_screen_provider.dart';
import '../../../home/provider/HomeScreenProvider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationOn = true;
  // String termsUrl =
  //     "https://www.iubenda.com/en/help/2859-terms-and-conditions-when-are-they-needed";
  // String privacyUrl =
  //     "https://www.iubenda.com/en/help/2859-terms-and-conditions-when-are-they-needed";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<Settingprovider>().settingsApi();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Settingprovider>();
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Settings"),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                hBox(18),

                _settingsTile(
                  icon: ImageConstants.bell,
                  title: "Push Notifications",
                  toggle: true,
                  notificationType: 'push',
                  provider: provider,
                ),

                _settingsTile(
                  icon: ImageConstants.email,
                  title: "Email Notifications",
                  toggle: true,
                  notificationType: 'email',
                  provider: provider,
                ),

                _settingsTile(
                  icon: ImageConstants.lock,
                  title: "Where you're logged in",
                  showArrow: true,
                  onTap: () {
                    // final homeProvider = context.read<HomeScreenProvider>();
                    // provider.syncHomeLocation(
                    //   context,
                    //   homeProvider.lat ?? "",
                    //   homeProvider.lng ?? "",
                    // );
                    Navigator.pushNamed(context, AppRoutes.loginDetails);
                  },
                ),

                _settingsTile(
                  icon: ImageConstants.document,
                  title: "Terms & Conditions",
                  showArrow: true,
                  onTap: () {
                    final url = provider.settingsData?.data?.termsUrl ?? "";

                    Navigator.pushNamed(
                      context,
                      AppRoutes.commonScreen,
                      arguments: CommonScreenArgs(
                        type: "Terms & Conditions ",
                        url: url,
                      ),
                    );
                  },
                ),

                _settingsTile(
                  icon: ImageConstants.document,
                  title: "Privacy Policy",
                  showArrow: true,
                  onTap: () async {
                    // final url =
                    //     provider.settingsData?.data?.privacyUrl ?? "";
                    // print("Launching URL: $url");
                    // if (url.isNotEmpty) {
                    //   final uri = Uri.parse(url);
                    //   if (!await launchUrl(
                    //     uri,
                    //     mode: LaunchMode.externalApplication,
                    //   )) {
                    //     print("Could not launch $url");
                    //   }
                    // }
                    final url = provider.settingsData?.data?.privacyUrl ?? "";

                    Navigator.pushNamed(
                      context,
                      AppRoutes.commonScreen,
                      arguments: CommonScreenArgs(
                        type: "Privacy Policy",
                        url: url,
                      ),
                    );
                  },
                ),

                _deleteTile(provider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // NORMAL TILE
  // --------------------------------------------------------------------------

  Widget _settingsTile({
    required String icon,
    required String title,
    bool toggle = false,
    bool showArrow = false,
    VoidCallback? onTap,
    String? notificationType,
    Settingprovider? provider,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.containerBorder),
        ),
        child: Row(
          children: [
            CustomImage(path: icon, height: 22, width: 22),
            SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: AppFontStyle.text_15_500(
                  AppColors.black,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ),

            if (toggle && provider != null)
              CustomToggleSwitch(
                value: notificationType == 'push'
                    ? provider.settingsData?.data?.isNotificationOn ?? false
                    : provider.settingsData?.data?.emailnotification ?? false,
                onChanged: (val) {
                  if (notificationType == 'push') {
                    provider.updateNotificationApi(context, pushValue: val);
                  } else {
                    provider.updateNotificationApi(context, emailValue: val);
                  }
                },
              ),

            if (showArrow) CustomImage(path: ImageConstants.rightBack),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // DELETE TILE
  // --------------------------------------------------------------------------

  Widget _deleteTile(Settingprovider provider) {
    return InkWell(
      onTap: () {
        showDeleteDialog(context, provider);
      },
      child: Container(
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.containerBorder),
        ),
        child: Row(
          children: [
            CustomImage(
              path: ImageConstants.bin,
              color: AppColors.red,
              height: 22,
              width: 22,
            ),
            SizedBox(width: 14),

            Text(
              "Delete Account",
              style: AppFontStyle.text_14_600(AppColors.red),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // DELETE POPUP
  // --------------------------------------------------------------------------

  Future<void> showDeleteDialog(
    BuildContext context,
    Settingprovider provider,
  ) async {
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
                  "Delete Account?",
                  style: AppFontStyle.text_20_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.semiBold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Are you sure you want to delete\nyour account?",
                  style: AppFontStyle.text_14_400(AppColors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 22),
                CustomButton(
                  text: "Yes, Delete",
                  borderRadius: BorderRadius.circular(30),
                  isLoading: provider.isLoading,
                  onPressed: () {
                    provider.deleteProfile(context);
                  },
                ),

                SizedBox(height: 12),

                CustomButton(
                  text: "No, Don’t Delete",
                  textStyle: AppFontStyle.text_14_500(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.medium,
                  ),
                  color: AppColors.grey,
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
