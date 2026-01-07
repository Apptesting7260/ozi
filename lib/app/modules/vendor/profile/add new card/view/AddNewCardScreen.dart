
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_check_box.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';

class VendorAddNewCardScreen extends StatefulWidget {
  const VendorAddNewCardScreen({super.key});

  @override
  State<VendorAddNewCardScreen> createState() => _VendorAddNewCardScreenState();
}

class _VendorAddNewCardScreenState extends State<VendorAddNewCardScreen> {

  bool isDefault = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [

            CustomAppBar(title: "Add New Card"),

            SizedBox(height: 20),

            CustomTextFormField(
              label: "Card Number",
              hintText: "1234 1234 1234 1234",
              borderRadius: 30,
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "Expiry Date",
                    hintText: "MM/YY",
                    borderRadius: 30,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    label: "CVV",
                    hintText: "CVV",
                    borderRadius: 30,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            CustomTextFormField(
              label: "Card Holder Name",
              hintText: "Enter card holder name",
              borderRadius: 30,
            ),

            SizedBox(height: 20),

            /// ---------- Custom Checkbox Row ----------
            Row(
              children: [
                CustomCheckbox(
                  value: isDefault,
                  width: 20,
                  height: 20,
                  onChanged: (val) {
                    setState(() => isDefault = val);
                  },
                ),
                SizedBox(width: 10),
                Text(
                  "Set as default",
                  style: AppFontStyle.text_14_400(AppColors.grey),
                ),
              ],
            ),

            SizedBox(height: 30),

            CustomButton(
              text: "Add Card",
              onPressed: () {
                // save card logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
