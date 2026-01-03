import '../../../core/appExports/app_export.dart';
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const WelcomeScreen(),
          ),
              (route) => false, // This removes all previous routes
        );
      }
    });
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