import '../../../core/appExports/app_export.dart';
import '../../../data/storage/user_preference.dart';
import '../../../modules/auth/vendor/signup/view/identity_verification_screen.dart';
import '../../../modules/auth/vendor/signup/view/service_category.dart';
import '../../../modules/auth/vendor/signup/view/set_availability.dart';
import '../../../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../../../modules/vendor/navigation tab/view/vendor_navigation_tab_screen.dart';
import '../../user_role/choose_your_role/view/choose_role.dart';
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
    String? step = await UserPreference.returnStep();
    String? userId = await UserPreference.returnUserId();
    if(isLogin&&token!=null&&role!=null){
      if(step=='0'){
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => ChooseRoleScreen(userId: userId,),
          ),
        );
      }else if(step=='1'&&role=='vendor'){
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => ServiceCategory(),
          ),
        );
      }else if(step=='2'&&role=='vendor'){
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => SetAvailabilityScreen(),
          ),
        );
      }else if(step=='3'&&role=='vendor'){
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => IdentityVerificationScreen(),
          ),
        );
      }else{
        if(role!=null&&token!=null){
          loginWithSaveTokenRedirection(role,token);
        }
      }
      // if(role=='user'){
      //   Navigator.push(
      //     navigatorKey.currentContext!,
      //     MaterialPageRoute(
      //       builder: (_) =>   NavigationTabScreen(),
      //     ),
      //   );
      // }else if(role=='vendor'){
      //   Navigator.push(
      //     navigatorKey.currentContext!,
      //     MaterialPageRoute(
      //       builder: (_) =>   VendorNavigationTabScreen(),
      //     ),
      //   );
      // }
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



  Future<void> loginWithSaveTokenRedirection(String? role,String? token) async {
    if(role==null||token==null){
      return;
    }
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