
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';

class VendorAddAddressScreen extends StatelessWidget {
  const VendorAddAddressScreen({super.key});

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
                _type("Home"),
                SizedBox(width: 8),
                _type("Work"),
                SizedBox(width: 8),
                _type("Other"),
              ],
            ),

            SizedBox(height: 32),
            CustomButton(
              text: "Save Address",
              onPressed: () {},),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _type(String title) {
    return Expanded(
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          title,
          style: AppFontStyle.text_14_500(AppColors.primary),
        ),
      ),
    );
  }
}
