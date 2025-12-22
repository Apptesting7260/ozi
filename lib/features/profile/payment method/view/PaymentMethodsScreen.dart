import '../../../../core/appExports/app_export.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_radio_button.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {

  int selectedIndex = 0; // default Visa selected

  List<String> methods = [
    "Visa •••• 4242",
    "Mastercard •••• 8888",
    "Cash",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [

          CustomAppBar(title: "Payment Methods"),

          Expanded(
            child: ListView(
              padding: REdgeInsets.symmetric(horizontal: 16),
              children: [
                SizedBox(height: 10),

                for (int i = 0; i < methods.length; i++)
                  _paymentTile(methods[i], i),

                hBox(10),
                CustomButton(
                  text: "+ Add New Card",
                  height: 52,
                  isOutlined: true,
                  borderRadius: BorderRadius.circular(60),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.addNewCardScreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentTile(String title, int index) {

    bool selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderColor,
          ),
          color: selected ? AppColors.primary.withOpacity(.10) : Colors.white,
        ),
        child: Row(
          children: [
            CustomImage(path: ImageConstants.card),
            SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: AppFontStyle.text_14_600(AppColors.black),
              ),
            ),

            CustomRadioButton(
              value: selected,
              onChanged: (_) {
                setState(() {
                  selectedIndex = index;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
