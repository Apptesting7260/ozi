import 'package:ozi/app/modules/user/profile/address%20map/view/location_picker.dart';
import 'package:ozi/app/modules/user/profile/login%20details/view/login_details.dart';
import 'package:ozi/app/modules/vendor/home/view/vendor_home_screen.dart';
import 'package:ozi/app/modules/vendor/navigation%20tab/view/vendor_navigation_tab_screen.dart';
import 'package:ozi/app/modules/vendor/services/view/service_screen.dart';
import '../core/appExports/app_export.dart';
import '../modules/user/help/view/help_screen.dart';
import '../modules/user/home/service details/view/ServiceDetailScreen.dart';
import '../modules/user/home/view/homescreen.dart';
import '../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../modules/user/profile/add new address/view/add_address_screen.dart';
import '../modules/user/profile/add new card/view/AddNewCardScreen.dart';
import '../modules/user/profile/common screen/provider/comman_screen_provider.dart';
import '../modules/user/profile/common screen/view/common_screen.dart';
import '../modules/user/profile/edit address/view/edit_user_address_screen.dart';
import '../modules/user/profile/edit profile/view/EditProfileScreen.dart';
import '../modules/user/profile/payment method/view/PaymentMethodsScreen.dart';
import '../modules/user/profile/save address/view/SavedAddressScreen.dart';
import '../modules/user/profile/setting/view/SettingsScreen.dart';
import '../modules/user/profile/view/profile_screen.dart';
import '../modules/vendor/bookings/view/vendor_mybookings_screen.dart';
import '../modules/vendor/profile/add new address/view/AddAddressScreen.dart';
import '../modules/vendor/profile/add new card/view/AddNewCardScreen.dart';
import '../modules/vendor/wallet/view/wallet_screen.dart';
import '../modules/vendor/wallet/withdraw/view/withdraw_screen.dart';
import '../view/auth/login/view/login_screen.dart';
import '../view/auth/verification_screen/view/verification_screen.dart';
import '../view/message/message_details/screens/message_details.dart';
import '../view/splash/view/splash_screen.dart';
import '../view/welcome/view/welcome_screen.dart';
import '../modules/user/booking/booking details/view/booking_details_screen.dart';

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
  static const String bookingDetailsScreen = '/bookingDetailsScreen';
  static const String navigationTab = '/navigationTab';
  static const String profile = '/profile';
  static const String cart = '/cart';
  static const String profileScreen = '/profileScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String savedAddressScreen = '/savedAddressScreen';
  static const String addAddressScreen = '/addAddressScreen';
  static const String editAddressScreen = '/editAddressScreen';
  static const String paymentMethodsScreen = '/paymentMethodsScreen';
  static const String addNewCardScreen = '/addNewCardScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String commonScreen = '/commonScreen';
  static const String helpSupportScreen = '/HelpSupportScreen';
  static const String loginDetails = '/LoginDetailScreen';

  //*********************************** vendor All Screens  ****************************************//

  static const String vendorNavigation = '/vendorNavigation';

  //******************************** Home screens *************************************//

  static const String vendorHomeScreen = '/vendorHomeScreen';
  static const String vendorNewRequestScreen = '/vendorNewRequestScreen';
  static const String vendorNotificationScreen = '/vendorNotificationScreen';

  //******************************** Bookings screens *************************************//

  static const String vendorBookingScreen = '/vendorBookingScreen';
  static const String vendorBookingDetailsScreen =
      '/vendorBookingDetailsScreen';

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
  static const String locationPickerScreen = '/locationPickerScreen';

  //******************************** Services screens *************************************//
  static const String vendorServicesScreen = '/vendorServicesScreen';
  static const String vendorAddNewService = '/vendorAddNewService';
  static const String vendorEditService = '/vendorEditService';
  static const String vendorFilterScreen = '/vendorFilterScreen';
  static const String vendorServiceDetailsScreen =
      '/vendorServiceDetailsScreen';

  //******************************** Wallet screens *************************************//
  static const String vendorWalletScreen = '/vendorWalletScreen';
  static const String vendorTransactionHistory = '/vendorTransactionHistory';
  static const String vendorWithdrawScreen = '/vendorWithdrawScreen';
  static const String messageDetailsScreen = '/messageDetailsScreen';

  static Route<dynamic>? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case welcomeScreen:
        return MaterialPageRoute(builder: (context) => WelcomeScreen());

      case login:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      case otpVerification:
        return MaterialPageRoute(
          builder: (context) => VerificationScreen(
            phone: '',
            verificationId: '',
            countryCode: '',
          ),
        );
      case messageDetailsScreen:
        final args = setting.arguments as Map<String, dynamic>;
        if (kDebugMode) {
          print("Here Args ============================> ${args['messageForSend']}");
        }
        return MaterialPageRoute(
          builder: (context) => MessageDetailsScreen(
            conversionId: args['conversion_id'],
            dataLink: args['dataLink'],
            messageForSend: args['messageForSend'],
          ),
          settings: RouteSettings(name: messageDetailsScreen),
        );

      // case createAccount:
      //   return MaterialPageRoute(builder: (context) => CreateAccountScreen());

      case navigationTab:
        return MaterialPageRoute(builder: (context) => NavigationTabScreen());

      case homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case serviceDetailScreen:
        return MaterialPageRoute(
          builder: (context) => ServiceDetailScreen(
            service: setting.arguments as dynamic,
            categoryId: setting.arguments as int,
          ),
        );
      case bookingDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => BookingDetailsScreen(
            bookingData: setting.arguments as Map<String, dynamic>,
            tabIndex: 0,
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

      case editAddressScreen:
        return MaterialPageRoute(builder: (_) => EditUserAddressScreen());

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
        return MaterialPageRoute(
          builder: (_) => CommonScreen(type: args.type, url: args.url),
        );

      case loginDetails:
        return MaterialPageRoute(builder: (_) => LoginDetailsScreen());

      //vendor screen

      case helpSupportScreen:
        final userRole = setting.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => HelpSupportScreen(userRole: userRole),
        );
      case vendorNavigation:
        return MaterialPageRoute(builder: (_) => VendorNavigationTabScreen());
      case vendorHomeScreen:
        return MaterialPageRoute(builder: (_) => VendorHomeScreen());
      case vendorBookingScreen:
        return MaterialPageRoute(builder: (_) => VendorMybookingsScreen());
      case vendorWalletScreen:
        return MaterialPageRoute(builder: (_) => VendorMyWalletScreen());
      case vendorWithdrawScreen:
        return MaterialPageRoute(
          builder: (_) => WithdrawScreen(availableBalance: ''),
        );
      case vendorServicesScreen:
        return MaterialPageRoute(builder: (_) => VendorServicesScreen());
      // case vendorProfileScreen:
      //   return MaterialPageRoute(builder: (_) => VendorProfileScreen());
      case vendorAddNewAddressScreen:
        return MaterialPageRoute(builder: (_) => VendorAddAddressScreen());
      case locationPickerScreen:
        return MaterialPageRoute(builder: (_) => MapPickerPage());
      case vendorAddNewCardScreen:
        return MaterialPageRoute(builder: (_) => VendorAddNewCardScreen());
      // case vendorBookingDetailsScreen:
      //   return MaterialPageRoute(builder: (_) => VendorBookingDetailsScreen(booking: ));

      default:
        // Ignore firebase auth deep links to prevent unwanted navigation to SplashScreen
        // when returning from Safari/Chrome reCAPTCHA verification.
        if (setting.name != null &&
            (setting.name!.startsWith('/__/') ||
                setting.name!.startsWith('app-1-') ||
                setting.name!.contains('firebaseauth') ||
                setting.name!.contains('com.googleusercontent') ||
                setting.name == '/')) {
          // Return null to let the plugin (Firebase Auth) handle the deep link internally
          // without Flutter router disrupting the current screen stack.
          return null;
        }
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }
}
