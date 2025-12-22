import 'package:ozi/features/cart/view/MyCartScreen.dart';
import 'package:ozi/features/help/view/help_screen.dart';
import '../../../core/appExports/app_export.dart';
import '../../booking/view/booking_screen.dart';
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
}
