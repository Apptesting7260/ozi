import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'core/appExports/app_export.dart';
import 'features/navigation tab/provider/navigation_provider.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// ===== IMPORTANT WEBVIEW PLATFORM SETUP =====
  if (WebViewPlatform.instance == null) {
    if (Platform.isAndroid) {
      WebViewPlatform.instance = AndroidWebViewPlatform();
    } else if (Platform.isIOS) {
      WebViewPlatform.instance = WebKitWebViewPlatform();
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),

      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return MaterialApp(
            title: 'Ozi Salon Services',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
              ),
              useMaterial3: false,
            ),

            /// =========================
            /// ROUTE SYSTEM ACTIVATED
            /// =========================
            initialRoute: AppRoutes.splashScreen,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
