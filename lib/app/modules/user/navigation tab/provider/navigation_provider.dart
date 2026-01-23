import '../../../../core/appExports/app_export.dart';
import '../../booking/view/booking_screen.dart';
import '../../cart/view/my_cart_screen.dart';
import '../../help/view/help_screen.dart';
import '../../home/view/homescreen.dart';
import '../../profile/view/profile_screen.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;



  // --------------------------------------------------------
  Future<void> setIndex(int index, BuildContext context) async {
    if (index >= 1) {
    }

    _currentIndex = index;
    notifyListeners();
  }

  final List<Widget> pages = [
    HomeScreen(),
    CartScreen(),
    MyBookingsScreen(),
    HelpSupportScreen(),
    ProfileScreen(),
  ];

  String getIconPath(int index, bool isActive) {
    switch (index) {
      case 0:
        return isActive ? ImageConstants.homeFill : ImageConstants.home;
      case 1:
        return isActive ? ImageConstants.cartFill : ImageConstants.cart;
      case 2:
        return isActive ? ImageConstants.bookingFill : ImageConstants.booking;
      case 3:
        return isActive ? ImageConstants.supportFill : ImageConstants.help;
      case 4:
        return isActive ? ImageConstants.profileFill : ImageConstants.profile;
      default:
        return ImageConstants.home;
    }
  }


}