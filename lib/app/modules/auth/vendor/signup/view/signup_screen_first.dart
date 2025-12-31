
import 'package:ozi/app/modules/auth/vendor/signup/view/signup_screen_second.dart';
import 'package:ozi/app/routes/app_routes.dart';

import '../../../../../core/appExports/app_export.dart';

class SignupScreenFirst extends StatefulWidget {
  const SignupScreenFirst({super.key});

  @override
  State<SignupScreenFirst> createState() => _SignupScreenFirstStateState();
}

class _SignupScreenFirstStateState extends State<SignupScreenFirst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Container(
                    height: 68,
                    width: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.2), // light green bg
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),

              hBox(24),

              /// Title
              Text(
                "Account Created!",
                style: AppFontStyle.text_22_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.bold,
                ),
              ),

              SizedBox(height: 10),

              /// Subtitle
              Text(
                maxLines: 4,
                "Your vendor account has been created successfully. "
                    "Complete your profile to start accepting bookings.",
                textAlign: TextAlign.center,
                style: AppFontStyle.text_15_400(AppColors.grey),
              ),

              SizedBox(height: 32),

              /// Continue Button
              CustomButton(
                text: "Complete Your Profile",
                height: 54,
                borderRadius: BorderRadius.circular(40),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreenSecond()));
                },
              ),

              SizedBox(height: 14),

              /// Skip Button (Outlined)
              CustomButton(
                text: "Skip for Now",
                textStyle: AppFontStyle.text_14_600(AppColors.black, fontFamily: AppFontFamily.semiBold),
                isOutlined: true,
                color: AppColors.lightGrey2,
                height: 54,
                borderRadius: BorderRadius.circular(40),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.vendorNavigation);
                  // Navigator.pop(context); // Or go home screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
