
import '../../../../../core/appExports/app_export.dart';
import '../../../../vendor/navigation tab/view/vendor_navigation_tab_screen.dart';

class ReadyToGoLiveScreen extends StatelessWidget {
  const ReadyToGoLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.12),
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                ),
              ),

              hBox(20),

              /// TITLE
              Text(
                "You're Ready to Go Live!",
                style: AppFontStyle.text_20_600(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.bold,
                ),
                textAlign: TextAlign.center,
              ),

              hBox(10),

              /// SUBTITLE
              Text(
                "Your profile is complete. Start accepting\nbookings and earning money with your skills.",
                style: AppFontStyle.text_14_400(AppColors.grey),
                textAlign: TextAlign.center,
              ),

              hBox(30),

              /// STEPS
              _stepTile(
                number: "1",
                text: "Turn on \"Online\" status to receive requests",
              ),
              hBox(14),
              _stepTile(
                number: "2",
                text: "Accept booking requests from customers",
              ),
              hBox(14),
              _stepTile(
                number: "3",
                text: "Complete jobs and get paid directly",
              ),

             hBox(20),
              CustomButton(
                height: 54,
                borderRadius: BorderRadius.circular(60),
                text: "Go to Home",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => VendorNavigationTabScreen()));
                },
              ),

              hBox(30),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // STEP TILE
  // --------------------------------------------------------------------------

  Widget _stepTile({
    required String number,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// NUMBER CIRCLE
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: AppFontStyle.text_12_600(AppColors.white),
            ),
          ),

          wBox(12),

          /// TEXT
          Expanded(
            child: Text(
              text,
              style: AppFontStyle.text_14_400(AppColors.darkText),
            ),
          ),
        ],
      ),
    );
  }
}
