
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [

            CustomAppBar(title: "Add New Address"),

            SizedBox(height: 10),

            CustomTextFormField(
              label: "Street Address",
              hintText: "123 Main Street",
              borderRadius: 14,
            ),

            SizedBox(height: 15),

            CustomTextFormField(
              label: "Apartment, Suite, etc.",
              hintText: "Apt 4B",
              borderRadius: 14,
            ),

            SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "City",
                    hintText: "New York",
                    borderRadius: 14,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    label: "ZIP Code",
                    hintText: "10001",
                    borderRadius: 14,
                  ),
                ),
              ],
            ),

            SizedBox(height: 25),

          Row(
            children: [
              _type("Home", ImageConstants.home),
              wBox(12),
              _type("Work", ImageConstants.work),
              wBox(12),
              _type("other", ImageConstants.location)
            ],
          ),


          hBox(22),
            CustomButton(
              text: "Save Address",
              onPressed: () {},),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _type(String title, String imagePath) {
    return Expanded(
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(
              path: imagePath,
              color: AppColors.primary,
              height: 18,
              width: 18,
            ),
            wBox(8),
            Text(
              title,
              style: AppFontStyle.text_14_500(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

}
