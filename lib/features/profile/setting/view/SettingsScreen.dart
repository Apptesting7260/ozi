import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_toggle_switch.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../common screen/view/common_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool notificationOn = true;
   String termsUrl = "https://www.iubenda.com/en/help/2859-terms-and-conditions-when-are-they-needed";
   String privacyUrl = "https://www.iubenda.com/en/help/2859-terms-and-conditions-when-are-they-needed";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [

          CustomAppBar(title: "Settings"),
          SizedBox(height: 18),

          _settingsTile(
            icon: ImageConstants.bell,
            title: "Push Notifications",
            toggle: true,
          ),

          _settingsTile(
            icon: ImageConstants.document,
            title: "Terms & Conditions",
            showArrow: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommonScreen(
                    type: "Terms & Conditions",
                    url: termsUrl,
                  ),
                ),
              );
            },
          ),


          _settingsTile(
            icon: ImageConstants.document,
            title: "Privacy Policy",
            showArrow: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommonScreen(
                    type: "Privacy Policy",
                    url: privacyUrl,
                  ),
                ),
              );
            },
          ),


          _deleteTile(),

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

            if (toggle)
              CustomToggleSwitch(
                value: notificationOn,
                onChanged: (val) {
                  setState(() => notificationOn = val);
                },
              ),

            if (showArrow)
              CustomImage(
                path: ImageConstants.rightBack,
              ),

          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // DELETE TILE
  // --------------------------------------------------------------------------

  Widget _deleteTile() {
    return InkWell(
      onTap: () {
        showDeleteDialog(context);
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
                  "Delete Account?",
                  style: AppFontStyle.text_18_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.bold,
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                SizedBox(height: 12),

                CustomButton(
                  text: "No, Don’t Delete",
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
