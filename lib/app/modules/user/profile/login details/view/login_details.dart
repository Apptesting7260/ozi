import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../provider/login_details_provider.dart';

class LoginDetailsScreen extends StatefulWidget {
  const LoginDetailsScreen({super.key});

  @override
  State<LoginDetailsScreen> createState() => _LoginDetailsScreenState();
}

class _LoginDetailsScreenState extends State<LoginDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<LoginDetailsProvider>(
        context,
        listen: false,
      ).fetchLoginDetails(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Provider.of<LoginDetailsProvider>(
            context,
            listen: false,
          ).fetchLoginDetails(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const CustomAppBar(title: "Login Details"),
              ),
              Expanded(
                child: Consumer<LoginDetailsProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                    if (provider.devices.isEmpty) {
                      return const Center(
                        child: Text("No login details found"),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      itemCount: provider.devices.length,
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 1,
                        color: Color(0xffcfd1d4),
                        indent: 16,
                        endIndent: 20,
                      ),
                      itemBuilder: (context, index) {
                        final device = provider.devices[index];

                        return _DeviceTile(
                          deviceName: device.deviceName ?? "",
                          city: device.city ?? "",
                          state: device.state ?? "",
                          country: device.country ?? "",
                          isCurrent: device.isCurrentDevice ?? false,
                          lastUsedAt: device.loggedInAt ?? "",
                          onTap: () {
                            if (!provider.isLogoutLoading(
                              device.id.toString(),
                            )) {
                              showDeleteDialog(context, () {
                                Navigator.pop(context);
                                provider.logoutFromDevice(device.id.toString());
                              });
                            }
                          },
                          provider: provider,
                          child: provider.isLogoutLoading(device.id.toString())
                              ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Logout",
                                  style: AppFontStyle.text_14_500(
                                    AppColors.black,
                                    fontFamily: AppFontFamily.regular,
                                  ),
                                ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _DeviceTile({
    required String deviceName,
    required String city,
    required String state,
    required String country,
    required bool isCurrent,
    required VoidCallback onTap,
    required LoginDetailsProvider provider,
    required String lastUsedAt,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              color: Color(0xffe7f7f1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomImage(
                path: ImageConstants.mobile,
                height: 20,
                width: 20,
              ),
            ),
          ),

          wBox(14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: AppFontStyle.text_16_400(
                    AppColors.black,
                    fontFamily: AppFontFamily.regular,
                  ),
                ),
                hBox(2),
                city.isNotEmpty || country.isNotEmpty
                    ? Text(
                        "$city • $country",
                        style: AppFontStyle.text_13_400(
                          AppColors.grey,
                          fontFamily: AppFontFamily.regular,
                        ),
                      )
                    : SizedBox.shrink(),
                //  wBox(4),
                // if (!isCurrent)
                //   Text(
                //     lastUsedAt == "Active now"
                //         ? lastUsedAt
                //         : "Last used on $lastUsedAt",
                //     style: AppFontStyle.text_13_400(
                //       AppColors.primary,
                //       fontFamily: AppFontFamily.regular,
                //     ),
                //   ),
              ],
            ),
          ),

          isCurrent
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffe0f4ec),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Current",
                      style: AppFontStyle.text_13_500(
                        AppColors.primary,
                        fontFamily: AppFontFamily.regular,
                      ),
                    ),
                  ),
                )
              : OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    side: const BorderSide(color: Color(0xffcfd1d4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: onTap,
                  child: child,
                ),
        ],
      ),
    );
  }

  Future<void> showDeleteDialog(
    BuildContext context,
    VoidCallback onTap,
  ) async {
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
                  onPressed: onTap,
                  // onPressed: () {
                  //   Navigator.pop(dialogContext);
                  //   provider.logout(context);
                  // },
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
