



import 'package:ozi/app/modules/vendor/home/view/vendor_home_screen.dart';
import 'package:ozi/app/modules/vendor/navigation%20tab/view/vendor_navigation_tab_screen.dart';
import 'package:ozi/app/modules/vendor/profile/view/vendor_profile_screen.dart';
import 'package:ozi/app/modules/vendor/services/view/service_screen.dart';
import '../core/appExports/app_export.dart';
import '../modules/user/help/view/help_screen.dart';
import '../modules/user/home/service details/view/ServiceDetailScreen.dart';
import '../modules/user/home/view/homescreen.dart';
import '../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../modules/user/profile/add new address/view/AddAddressScreen.dart';
import '../modules/user/profile/add new card/view/AddNewCardScreen.dart';
import '../modules/user/profile/common screen/provider/comman_screen_provider.dart';
import '../modules/user/profile/common screen/view/common_screen.dart';
import '../modules/user/profile/edit profile/view/EditProfileScreen.dart';
import '../modules/user/profile/payment method/view/PaymentMethodsScreen.dart';
import '../modules/user/profile/save address/view/SavedAddressScreen.dart';
import '../modules/user/profile/setting/view/SettingsScreen.dart';
import '../modules/user/profile/view/profile_screen.dart';
import '../modules/vendor/bookings/view/vendor_mybookings_screen.dart';
import '../modules/vendor/profile/add new address/view/AddAddressScreen.dart';
import '../modules/vendor/profile/add new card/view/AddNewCardScreen.dart';
import '../modules/vendor/wallet/view/wallet_screen.dart';
import '../view/auth/create account/view/create_account_screen.dart';
import '../view/auth/login/view/login_screen.dart';
import '../view/auth/verification_screen/view/verification_screen.dart';
import '../view/splash/view/splash_screen.dart';
import '../view/welcome/view/welcome_screen.dart';

class AppRoutes {

  static const String splashScreen = '/splashScreen';
  static const String welcomeScreen = '/welcomeScreen';
  static const String login = '/login';
  // static const String createAccount = '/createAccount';
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
  static const String helpSupportScreen = '/HelpSupportScreen';



  //*********************************** vendor All Screens  ****************************************//

  static const String vendorNavigation = '/vendorNavigation';

  //******************************** Home screens *************************************//

  static const String vendorHomeScreen = '/vendorHomeScreen';
  static const String vendorNewRequestScreen = '/vendorNewRequestScreen';
  static const String vendorNotificationScreen = '/vendorNotificationScreen';

  //******************************** Bookings screens *************************************//

  static const String vendorBookingScreen = '/vendorBookingScreen';
  static const String vendorBookingDetailsScreen = '/vendorBookingDetailsScreen';

  //******************************** Profiles screens *************************************//
  static const String vendorProfileScreen = '/vendorProfileScreen';
  static const String vendorSettingScreen = '/vendorSettingScreen';
  static const String vendorSaveAddressScreen = '/vendorSaveAddressScreen';
  static const String vendorPaymentMethodScreen = '/vendorPaymentMethodScreen';
  static const String vendorHelpScreen = '/vendorHelpScreen';
  static const String vendorEditProfileScreen = '/vendorEditProfileScreen';
  static const String vendorCommonScreen = '/vendorCommonScreen';
  static const String vendorAddNewCardScreen = '/vendorAddNewCardScreen';
  static const String vendorAddNewAddressScreen = '/vendorAddNewAddressScreen';

  //******************************** Services screens *************************************//
  static const String vendorServicesScreen = '/vendorServicesScreen';
  static const String vendorAddNewService = '/vendorAddNewService';
  static const String vendorEditService = '/vendorEditService';
  static const String vendorFilterScreen = '/vendorFilterScreen';
  static const String vendorServiceDetailsScreen = '/vendorServiceDetailsScreen';

  //******************************** Wallet screens *************************************//
  static const String vendorWalletScreen = '/vendorWalletScreen';
  static const String vendorTransactionHistory = '/vendorTransactionHistory';
  static const String vendorWithdrawScreen = '/vendorWithdrawScreen';



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

      // case createAccount:
      //   return MaterialPageRoute(builder: (context) => CreateAccountScreen());

      case navigationTab:
        return MaterialPageRoute(builder: (context) => NavigationTabScreen());

      case homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case serviceDetailScreen:
        return MaterialPageRoute(
          builder: (context) => ServiceDetailScreen(service: setting.arguments as dynamic,
          ),
        );

    // NEW PROFILE ROUTES

    //

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

//vendor screen

      case helpSupportScreen:
        return MaterialPageRoute(builder: (_) => HelpSupportScreen());
      case vendorNavigation:
        return MaterialPageRoute(builder: (_) => VendorNavigationTabScreen());
      case vendorHomeScreen:
        return MaterialPageRoute(builder: (_) => VendorHomeScreen());
      case vendorBookingScreen:
        return MaterialPageRoute(builder: (_) => VendorMybookingsScreen());
      case vendorWalletScreen:
        return MaterialPageRoute(builder: (_) => VendorMyWalletScreen());
      case vendorServicesScreen:
        return MaterialPageRoute(builder: (_) => VendorServicesScreen());
      case vendorProfileScreen:
        return MaterialPageRoute(builder: (_) => VendorProfileScreen());
      case vendorAddNewAddressScreen:
        return MaterialPageRoute(builder: (_) => VendorAddAddressScreen());
      case vendorAddNewCardScreen:
        return MaterialPageRoute(builder: (_) => VendorAddNewCardScreen());
      // case vendorBookingDetailsScreen:
      //   return MaterialPageRoute(builder: (_) => VendorBookingDetailsScreen(booking: ));


      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }

}
