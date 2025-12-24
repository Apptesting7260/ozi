import '../../../core/appExports/app_export.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: CustomImage(
        path: ImageConstants.splashLogo,
        width: size.width * 0.4,
        height: size.height * 0.20,
        fit: BoxFit.contain,
      ),
    );
  }
}
