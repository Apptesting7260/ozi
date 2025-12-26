import '../../../../core/appExports/app_export.dart';
import '../../../user/booking/view/booking_screen.dart';
import '../../../user/cart/view/MyCartScreen.dart';
import '../../../user/help/view/help_screen.dart';
import '../../../user/profile/view/profile_screen.dart';
import '../../home/view/vendor_home_screen.dart';


class VendorNavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  // Future<bool> _isLoggedIn() async {
  //   final token = await UserPreference.returnAccessToken();
  //   return token != null && token.isNotEmpty;
  // }

  // --------------------------------------------------------
  Future<void> setIndex(int index, BuildContext context) async {
    if (index >= 1) {
      // final loggedIn = await _isLoggedIn();

    }

    _currentIndex = index;
    notifyListeners();
  }

  // --------------------------------------------------------
  final List<Widget> pages = [
    VendorHomeScreen(),
    CartScreen(),
    MyBookingsScreen(),
    HelpSupportScreen(),
    ProfileScreen(),
  ];
}
