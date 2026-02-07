import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:ozi/app/modules/user/profile/add%20new%20address/provider/add_address_provider.dart';
import 'package:ozi/app/modules/user/profile/edit%20address/provider/edit_user_address_provider.dart';
import 'package:ozi/app/modules/vendor/navigation%20tab/provider/navigation_provider.dart';
import 'package:ozi/app/view/auth/login/provider/login_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'app/core/appExports/app_export.dart';
import 'app/modules/user/home/provider/HomeScreenProvider.dart';
import 'app/modules/user/navigation tab/provider/navigation_provider.dart';
import 'app/modules/user/profile/save address/provider/saved_address_provider.dart';
import 'app/modules/user/profile/view/profile_provider/profile_provider.dart';
import 'app/routes/app_routes.dart';
import 'app/view/splash/provider/splash_provider.dart';
import 'app/modules/user/cart/view/cupponprovider.dart';
import 'app/modules/user/cart/view/provider/cart_provider.dart';
import 'app/data/repository/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (WebViewPlatform.instance == null) {
    if (Platform.isAndroid) {
      WebViewPlatform.instance = AndroidWebViewPlatform();
    } else if (Platform.isIOS) {
      WebViewPlatform.instance = WebKitWebViewPlatform();
    }
  }
  ChuckerFlutter.showOnRelease = false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => VendorNavigationProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SavedAddressProvider()),
        ChangeNotifierProvider(create: (_) => AddAddressProvider()),
        ChangeNotifierProvider(create: (_) => EditUserAddressProvider()),
        ChangeNotifierProvider(create: (_) => CupponProvider()),
        ChangeNotifierProvider(
          create: (_) => CartProvider(repository: Repository()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return SafeArea(
            top: false,
            child: MaterialApp(
              title: 'Ozi Salon Services',
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: AppColors.primary,
                scaffoldBackgroundColor: AppColors.white,
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                useMaterial3: false,
              ),
              initialRoute: AppRoutes.splashScreen,
              navigatorObservers: [ChuckerFlutter.navigatorObserver],
              onGenerateRoute: AppRoutes.generateRoute,
            ),
          );
        },
      ),
    );
  }
}
