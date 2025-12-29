import 'package:ozi/app/modules/vendor/wallet/withdraw/view/withdraw_screen.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../provider/wallet_provider.dart';
import '../transaction_history/view/transaction_history_screen.dart';

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletProvider(),
      child: const _MyWalletContent(),
    );
  }
}

class _MyWalletContent extends StatelessWidget {
  const _MyWalletContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text("My Wallet" , style: AppFontStyle.text_24_600(AppColors.darkText, fontFamily: AppFontFamily.semiBold)),

              hBox(20),

              /// ================= BALANCE =================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Available Balance",
                              style: AppFontStyle.text_14_400(AppColors.white),
                            ),
                            Text(
                              "\$${provider.availableBalance.toStringAsFixed(2)}",
                              style: AppFontStyle.text_26_600(
                                AppColors.white,
                                fontFamily: AppFontFamily.bold,
                              ),
                            ),

                          ],
                        ),
                        Spacer(),
                        CustomImage(path: ImageConstants.wallet, color: AppColors.white, height: 25, width: 25,)
                      ],
                    ),

                    hBox(16),

                    CustomButton(
                      height: 44,
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.white,
                      onPressed: (){Navigator.push(context,
                          MaterialPageRoute(builder: (_) => WithdrawScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImage(
                            path: ImageConstants.withdraw,
                            height: 18,
                            width: 18,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 8),
                          Text(
                            "Withdraw",
                            style: AppFontStyle.text_14_500(AppColors.primary),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              hBox(20),

              /// ================= STATS =================
              Row(
                children: [
                  Expanded(
                    child: _statTile(
                      title:
                      "\$${provider.todayEarning.toStringAsFixed(2)}",
                      subtitle: "Today's Earning",
                    ),
                  ),
                  wBox(12),
                  Expanded(
                    child: _statTile(
                      title: "\$${provider.weeklyEarning}",
                      subtitle: "This Week",
                    ),
                  ),
                ],
              ),

              hBox(24),

              /// ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: AppFontStyle.text_16_600(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionHistoryScreen()));
                    },
                    child: Row(
                      children: [
                        Text(
                          "View All",
                          style:
                          AppFontStyle.text_14_500(AppColors.primary),
                        ),
                        wBox(5),
                        CustomImage(path: ImageConstants.rightBack, color: AppColors.primary,)
                      ],
                    ),
                  ),
                ],
              ),

              hBox(12),

              /// ================= LIST =================
              ...provider.transactions.map(
                    (tx) => _transactionTile(tx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= STAT TILE =================
  Widget _statTile({
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppFontStyle.text_18_600(
              AppColors.darkText,
              fontFamily: AppFontFamily.bold,
            ),
          ),
          hBox(4),
          Text(
            subtitle,
            style: AppFontStyle.text_12_400(AppColors.grey),
          ),
        ],
      ),
    );
  }

  /// ================= TRANSACTION TILE =================
  Widget _transactionTile(WalletTransaction tx) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: tx.isCredit
                  ? AppColors.primary.withValues(alpha: 0.20)
                  : Colors.red.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomImage(
                path: tx.isCredit
                    ? ImageConstants.downwardArrow
                    : ImageConstants.upwardArrow,
                height: 10,
                width: 10,
                color: tx.isCredit ? AppColors.primary : Colors.red,
              ),
            ),

          ),

          wBox(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title,
                    style:
                    AppFontStyle.text_14_600(AppColors.darkText)),
                hBox(2),
                Text(tx.user,
                    style:
                    AppFontStyle.text_12_400(AppColors.grey)),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${tx.isCredit ? '+' : '-'}\$${tx.amount}",
                style: AppFontStyle.text_14_600(
                  tx.isCredit ? AppColors.primary : Colors.red,
                ),
              ),
              hBox(2),
              Text(tx.time,
                  style:
                  AppFontStyle.text_11_400(AppColors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
