
import 'package:ozi/app/modules/auth/vendor/signup/view/service_category.dart';

import '../../../../../core/appExports/app_export.dart';

class SignupScreenSecond extends StatefulWidget {
  const SignupScreenSecond({super.key});

  @override
  State<SignupScreenSecond> createState() => _SignupScreenSecondState();
}

class _SignupScreenSecondState extends State<SignupScreenSecond> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding:  EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.10),
              ),
              child: Center(
                child: CustomImage(path: ImageConstants.wrench)
              ),
            ),

            hBox(10),

            /// TITLE
            Text(
              "Start Earning as a Service Provider",
              style: AppFontStyle.text_22_600(
                AppColors.black,
                fontFamily: AppFontFamily.bold,
              ),
            ),

            hBox(10),

            /// SUBTITLE
            Text(
              maxLines: 3,
              "Join thousands of professionals providing quality services and earning on their own terms",
              style: AppFontStyle.text_15_400(
                AppColors.grey,
              ),
            ),

            hBox(28),

            /// FEATURE LIST
            featureTile(
              icon: ImageConstants.dollar,
              title: "Earn on Your Schedule",
              subtitle: "Work when you want, earn what you deserve",
            ),
            hBox(18),

            featureTile(
              icon: ImageConstants.shield,
              title: "Secure Payments",
              subtitle: "Get paid directly to your bank account",
            ),
            hBox(18),

            featureTile(
              icon: ImageConstants.wrench,
              title: "Easy Job Management",
              subtitle: "Accept, track, and complete jobs easily",
            ),

            hBox(40),

            /// CTA BUTTON
            CustomButton(
              height: 52,
              borderRadius: BorderRadius.circular(40),
              text: "Get Started",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceCategory()));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- FEATURE TILE WIDGET ----------------
  Widget featureTile({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Icon Circle
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              height: 20,
              width: 20,
              colorFilter:
              ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
          ),
        ),

        wBox(14),

        /// Texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFontStyle.text_14_600(AppColors.black,
                    fontFamily: AppFontFamily.semiBold),
              ),
              hBox(4),
              Text(
                subtitle,
                style: AppFontStyle.text_14_400(AppColors.grey),
              ),
            ],
          ),
        )
      ],
    );
  }
}
