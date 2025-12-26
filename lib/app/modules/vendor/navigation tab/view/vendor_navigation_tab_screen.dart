import 'package:ozi/app/modules/vendor/navigation%20tab/provider/navigation_provider.dart';

import '../../../../core/appExports/app_export.dart';

class VendorNavigationTabScreen extends StatefulWidget {
  final int? initialIndex;

  const VendorNavigationTabScreen({super.key, this.initialIndex});

  @override
  State<VendorNavigationTabScreen> createState() => _VendorNavigationTabScreenState();
}

class _VendorNavigationTabScreenState extends State<VendorNavigationTabScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navProvider = context.read<VendorNavigationProvider>();
      navProvider.setIndex(widget.initialIndex ?? 0, context);
    });
  }

  Widget navIcon({required String path, required bool isActive}) {
    return CustomImage(
      path: path,
      width: 22.0,
      height: 22.0,
      color: isActive ? AppColors.primary : AppColors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        CustomConfirmationDialog.show(
          context,
          title: "Hold on!",
          subtitle: "Do you really want to leave? We'll miss you!",
          onYesPressed: () {
            SystemNavigator.pop();
          },
        );
      },
      child: Scaffold(
        body: Consumer<VendorNavigationProvider>(
          builder: (context, navProvider, _) {
            return navProvider.pages[navProvider.currentIndex];
          },
        ),
        bottomNavigationBar:
        Consumer<VendorNavigationProvider>(
          builder: (context, navProvider, _) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1A051331),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    unselectedLabelStyle: AppFontStyle.text_12_400(
                      AppColors.primary,
                    ),
                    selectedLabelStyle: AppFontStyle.text_12_600(
                      AppColors.primary,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                    currentIndex: navProvider.currentIndex,
                    onTap: (index) {
                      navProvider.setIndex(index, context);
                    },
                    backgroundColor: AppColors.transparent,
                    elevation: 0,
                    selectedItemColor: AppColors.primary,
                    unselectedItemColor: AppColors.grey,
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding:  EdgeInsets.only(bottom: 4.0),
                          child: navIcon(
                            path: ImageConstants.home,

                            isActive: navProvider.currentIndex == 0,
                          ),
                        ),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: navIcon(
                            path: ImageConstants.booking,
                            isActive: navProvider.currentIndex == 1,
                          ),
                        ),
                        label: 'Booking',
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding:  EdgeInsets.only(bottom: 4.0),
                          child: navIcon(
                            path: ImageConstants.wallet,
                            isActive: navProvider.currentIndex == 2,
                          ),
                        ),
                        label: 'Wallet',
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: navIcon(
                            path: ImageConstants.wrench,
                            isActive: navProvider.currentIndex == 3,
                          ),
                        ),
                        label: 'Services',
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: navIcon(
                            path: ImageConstants.profile,
                            isActive: navProvider.currentIndex == 4,
                          ),
                        ),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
                // Top indicator
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: List.generate(5, (index) {
                      return Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.03,
                          ),
                          decoration: BoxDecoration(
                            color: navProvider.currentIndex == index
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(2),
                              bottomRight: Radius.circular(2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}