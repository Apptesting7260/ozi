import '../../../core/appExports/app_export.dart';
import '../../../data/storage/user_preference.dart';
import '../../../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../../../modules/vendor/navigation tab/view/vendor_navigation_tab_screen.dart';
import '../../welcome/view/welcome_screen.dart';
import '../provider/splash_provider.dart';
import '../widget/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<SplashProvider>();
    provider.startTimer(context, () {
      if (mounted) {
        authInit(context);
      }
    });
  }

  Future<void>  authInit(BuildContext context)async {
    bool isLogin = await UserPreference.returnIsLoggedIn()??false;
    String? token = await UserPreference.returnAccessToken();
    String? role = await UserPreference.returnRole();
    if(isLogin&&token!=null&&role!=null){
      if(role=='user'){
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) =>   NavigationTabScreen(),
          ),
        );
      }else if(role=='vendor'){
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) =>   VendorNavigationTabScreen(),
          ),
        );
      }
    }else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        ),
            (route) => false, // This removes all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SplashLogo(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}