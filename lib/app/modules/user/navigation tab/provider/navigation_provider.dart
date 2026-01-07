import '../../../../core/appExports/app_export.dart';
import '../../booking/view/booking_screen.dart';
import '../../cart/view/MyCartScreen.dart';
import '../../help/view/help_screen.dart';
import '../../home/view/homescreen.dart';
import '../../profile/view/profile_screen.dart';

class NavigationProvider extends ChangeNotifier {
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
    HomeScreen(),
    CartScreen(),
    MyBookingsScreen(),
    HelpSupportScreen(),
    ProfileScreen(),
  ];

  // --------------------------------------------------------
  // Navigation icon paths
  String getIconPath(int index, bool isActive) {
    switch (index) {
      case 0: // Home
        return isActive ? ImageConstants.homeFill : ImageConstants.home;
      case 1: // Cart
        return isActive ? ImageConstants.cartFill : ImageConstants.cart;
      case 2: // Bookings
        return isActive ? ImageConstants.bookingFill : ImageConstants.booking;
      case 3: // Help
        return isActive ? ImageConstants.helpFill2 : ImageConstants.help;
      case 4: // Profile
        return isActive ? ImageConstants.profileFill : ImageConstants.profile;
      default:
        return ImageConstants.home;
    }
  }
}