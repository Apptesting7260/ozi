

import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../booking confirmed/view/BookingConfirmScreen.dart';
import '../provider/CheckoutProvider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckoutProvider(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(title: "Checkout"),
              Expanded(
                child: Consumer<CheckoutProvider>(
                  builder: (context, provider, _) {
                    return ListView(
                      padding: REdgeInsets.symmetric(horizontal: 16),
                      children: [
                        hBox(10),
                        _serviceCard(
                          img: ImageConstants.onboard1,
                          title: "Shirt Sleeve Shortening & Fitting",
                          date: "Today",
                          time: "2:00 PM",
                        ),
          
                         hBox(10),
                        _serviceCard(
                          img: ImageConstants.onboard2,
                          title: "Shirt Sleeve Shortening & Fitting",
                          date: "Dec 10, 2025",
                          time: "2:00 PM",
                        ),
          
                    hBox(10),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Service Address',
                              style:  AppFontStyle.text_16_500( AppColors.black, fontFamily: AppFontFamily.medium
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                              },
                              child:  Text(
                                'Change Address >',
                                style:  AppFontStyle.text_14_500( AppColors.primary, fontFamily: AppFontFamily.medium),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding:  EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color:  AppColors.containerBorder),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding:  EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:   Color(0xFFF1F1F3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child:  CustomImage(path: ImageConstants.home2, color: AppColors.black,)
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Home',
                                      style:  AppFontStyle.text_14_600( AppColors.black, fontFamily: AppFontFamily.semiBold
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '123 Main Street, San Francisco, CA',
                                      style:  AppFontStyle.text_14_400( AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
          
                        SizedBox(height: 12),
          
                        // ========== PAYMENT METHOD ==========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment Method',
                              style:  AppFontStyle.text_16_500( AppColors.black, fontFamily: AppFontFamily.medium
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                              },
                              child:  Text(
                                'Change method >',
                                style:  AppFontStyle.text_14_500( AppColors.primary, fontFamily: AppFontFamily.medium
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding:  EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color:  Color(0xFFE0E0E0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding:  EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:  Color(0xFFF1F1F3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child:  Icon(
                                  Icons.credit_card,
                                  color: Colors.black54,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Credit Card',
                                      style:  AppFontStyle.text_14_600( AppColors.black, fontFamily: AppFontFamily.semiBold
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '•••• •••• •••• 4242',
                                      style:  AppFontStyle.text_14_400( AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
          
                        SizedBox(height: 24),
          
                        _summary(provider),

                      ],
                    );
                  },
                ),
              ),
          
              _bottomConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceCard({
    required String img,
    required String title,
    required String date,
    required String time,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomImage(path: img, fit: BoxFit.cover),
          ),

          wBox(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFontStyle.text_14_600(AppColors.black),
                ),
                hBox(6),
                Row(
                  children: [
                    CustomImage(path: ImageConstants.calendor),
                    wBox(4),
                    Text(
                      date,
                      style: AppFontStyle.text_12_500(AppColors.darkText),
                    ),
                     wBox(10),
                    CustomImage(path: ImageConstants.clock),
                    wBox(4),
                    Text(
                      time,
                      style: AppFontStyle.text_12_500(AppColors.darkText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(CheckoutProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Summary",
          style: AppFontStyle.text_16_700(AppColors.black),
        ),

        SizedBox(height: 10),

        _summaryRow("Subtotal", provider.subtotal),
        _summaryRow("Service Fee", provider.serviceFee),

        Divider(height: 22),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: AppFontStyle.text_16_700(AppColors.black),
            ),
            Text(
              "\$${provider.total.toStringAsFixed(2)}",
              style: AppFontStyle.text_16_600(AppColors.primary, fontFamily: AppFontFamily.semiBold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppFontStyle.text_16_400(AppColors.grey)),
          Text("\$${amount.toStringAsFixed(2)}",
              style: AppFontStyle.text_16_400(AppColors.black)),
        ],
      ),
    );
  }

  Widget _bottomConfirmButton(BuildContext context) {
    return Padding(
      padding: REdgeInsets.all(16),
      child: CustomButton(
        text: "Confirm & Pay \$173.26",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingConfirmScreen(),
            ),
          );
        },
        height: 55,
        borderRadius: BorderRadius.circular(60),
      ),
    );
  }
}
