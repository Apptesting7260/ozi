import 'package:ozi/features/home/service%20details/view/ServiceDetailScreen.dart';
import 'package:ozi/features/profile/common%20screen/view/common_screen.dart';
import 'package:ozi/features/splash/view/splash_screen.dart';
import 'package:ozi/features/welcome/view/welcome_screen.dart';

import '../core/appExports/app_export.dart';
import '../features/auth/create account/view/create_account_screen.dart';
import '../features/auth/login/view/login_screen.dart';
import '../features/auth/verification_screen/view/VerificationScreen.dart';
import '../features/home/view/homescreen.dart';
import '../features/navigation tab/view/navigation_tab_screen.dart';
import '../features/profile/add new address/view/AddAddressScreen.dart';
import '../features/profile/add new card/view/AddNewCardScreen.dart';
import '../features/profile/common screen/provider/comman_screen_provider.dart';
import '../features/profile/edit profile/view/EditProfileScreen.dart';
import '../features/profile/payment method/view/PaymentMethodsScreen.dart';
import '../features/profile/save address/view/SavedAddressScreen.dart';
import '../features/profile/setting/view/SettingsScreen.dart';
import '../features/profile/view/profile_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String welcomeScreen = '/welcomeScreen';
  static const String login = '/login';
  static const String createAccount = '/createAccount';
  static const String otpVerification = '/otpVerification';
  static const String homeScreen = '/homeScreen';
  static const String serviceDetailScreen = '/serviceDetailScreen';
  static const String bookingSummaryScreen = '/bookingSummaryScreen';
  static const String bookingConfirmationScreen = '/bookingConfirmationScreen';
  static const String navigationTab = '/navigationTab';
  static const String profile = '/profile';
  static const String cart = '/cart';
  static const String profileScreen = '/profileScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String savedAddressScreen = '/savedAddressScreen';
  static const String addAddressScreen = '/addAddressScreen';
  static const String paymentMethodsScreen = '/paymentMethodsScreen';
  static const String addNewCardScreen = '/addNewCardScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String commonScreen = '/commonScreen';


  static Route<dynamic>? generateRoute(RouteSettings setting) {
    switch (setting.name) {

      case splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case welcomeScreen:
        return MaterialPageRoute(builder: (context) => WelcomeScreen());

      case login:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      case otpVerification:
        return MaterialPageRoute(builder: (context) => VerificationScreen(phone: '',));

      case createAccount:
        return MaterialPageRoute(builder: (context) => CreateAccountScreen());

      case navigationTab:
        return MaterialPageRoute(builder: (context) => NavigationTabScreen());

      case homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case serviceDetailScreen:
        return MaterialPageRoute(
          builder: (context) => ServiceDetailScreen(
            service: setting.arguments as dynamic,
          ),
        );

    // NEW PROFILE ROUTES

      case profileScreen:
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case editProfileScreen:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());

      case savedAddressScreen:
        return MaterialPageRoute(builder: (_) => SavedAddressScreen());

      case addAddressScreen:
        return MaterialPageRoute(builder: (_) => AddAddressScreen());

      case paymentMethodsScreen:
        return MaterialPageRoute(builder: (_) => PaymentMethodsScreen());

      case addNewCardScreen:
        return MaterialPageRoute(builder: (_) => AddNewCardScreen());

      case settingsScreen:
        return MaterialPageRoute(builder: (_) => SettingsScreen());

      case commonScreen:
        final args = setting.arguments as CommonScreenArgs;
        return MaterialPageRoute(builder: (_) => CommonScreen(type: args.type, url: args.url,),);


      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }

}
