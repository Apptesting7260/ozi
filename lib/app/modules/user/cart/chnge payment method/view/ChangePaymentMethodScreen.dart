import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_radio_button.dart';
import '../provider/PaymentMethodProvider.dart';

class ChangePaymentMethodScreen extends StatelessWidget {
  final String? selectedMethodTitle;
  const ChangePaymentMethodScreen({super.key, this.selectedMethodTitle});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentMethodProvider(initialTitle: selectedMethodTitle),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Consumer<PaymentMethodProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                CustomAppBar(title: "Change Method"),

                Expanded(
                  child: ListView(
                    padding: REdgeInsets.symmetric(horizontal: 16),
                    children: [
                      hBox(10),

                      ...List.generate(provider.list.length, (index) {
                        final data = provider.list[index];
                        final isSelected = provider.selectedIndex == index;

                        return GestureDetector(
                          onTap: () => provider.selectCard(index),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 14),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.containerBorder,
                              ),
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: .08)
                                  : AppColors.white,
                            ),
                            child: Row(
                              children: [
                                _leadingIcon(data.icon, isSelected),
                                SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            data.title,
                                            style: AppFontStyle.text_16_700(
                                              AppColors.black,
                                              fontFamily:
                                                  AppFontFamily.semiBold,
                                            ),
                                          ),

                                          if (data.masked.isNotEmpty) ...[
                                            SizedBox(width: 4),
                                            Text(
                                              data.masked,
                                              style: AppFontStyle.text_14_500(
                                                AppColors.darkText,
                                              ),
                                            ),
                                          ],

                                          if (data.label != null) ...[
                                            SizedBox(width: 6),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 1,
                                              ),
                                              child: Text(
                                                data.label!,
                                                style: AppFontStyle.text_13_400(
                                                  AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                CustomRadioButton(
                                  value: isSelected,
                                  onChanged: (_) => provider.selectCard(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 50),
                    ],
                  ),
                ),

                Padding(
                  padding: REdgeInsets.all(16),
                  child: CustomButton(
                    text: "Continue",
                    onPressed: () {
                      Navigator.pop(
                        context,
                        provider.list[provider.selectedIndex],
                      );
                    },
                    height: 50,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _leadingIcon(String iconPath, bool isSelected) {
    return Container(
      height: 34,
      width: 40,
      padding: EdgeInsets.all(8),
      child: CustomImage(
        path: iconPath,
        color: isSelected ? AppColors.primary : AppColors.black,
      ),
    );
  }
}
