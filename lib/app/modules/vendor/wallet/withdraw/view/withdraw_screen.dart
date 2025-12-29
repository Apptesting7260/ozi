import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/withdraw_provider.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WithdrawProvider(),
      child: const _WithdrawContent(),
    );
  }
}

class _WithdrawContent extends StatelessWidget {
  const _WithdrawContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WithdrawProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(title: "Withdraw"),

              hBox(24),

              /// BALANCE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text("Available Balance",
                        style:
                        AppFontStyle.text_12_400(AppColors.black)),
                    hBox(4),
                    Text(
                      "\$${provider.balance.toStringAsFixed(2)}",
                      style:
                      AppFontStyle.text_22_600(AppColors.primary),
                    ),
                  ],
                ),
              ),

              hBox(24),

              Text("Withdrawal Amount",
                  style:
                  AppFontStyle.text_14_600(AppColors.darkText)),

              hBox(8),

              CustomTextFormField(
                hintText: "Min Amount \$50",
                prefix: Text("    \$",
                    style:
                    AppFontStyle.text_16_600(AppColors.primary)),
                borderRadius: 40,
              ),

              hBox(16),

              Wrap(
                spacing: 10,
                children: provider.quickAmounts.map((amt) {
                  final selected = provider.selectedAmount == amt;
                  return GestureDetector(
                    onTap: () => provider.selectAmount(amt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.black,
                        ),
                      ),
                      child: Text(
                        "\$$amt",
                        style: AppFontStyle.text_14_600(
                          selected
                              ? AppColors.primary
                              : AppColors.darkText,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            hBox(20),
              CustomButton(
                height: 54,
                text: "Continue",
                borderRadius: BorderRadius.circular(60),
                color: provider.canContinue
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.70),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
