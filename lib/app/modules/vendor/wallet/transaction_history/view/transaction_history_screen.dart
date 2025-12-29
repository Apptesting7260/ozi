import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/transaction_history_provider.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionHistoryProvider(),
      child: const _TransactionHistoryContent(),
    );
  }
}

class _TransactionHistoryContent extends StatelessWidget {
  const _TransactionHistoryContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionHistoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CustomAppBar(title: "Transaction History"),

              hBox(16),

              /// SEARCH
              CustomTextFormField(
                hintText: "Search...",
                prefix: Icon(Icons.search, color: AppColors.grey),
                borderRadius: 40,
              ),

              hBox(12),

              /// FILTERS
              Row(
                children: [
                  _filter("All", provider),
                  wBox(8),
                  _filter("This Month", provider),
                  wBox(8),
                  _filter("Last 6 Months", provider),
                ],
              ),

              hBox(20),

              /// LIST
              Expanded(
                child: ListView.separated(
                  itemCount: provider.transactions.length,
                  separatorBuilder: (_, __) => Divider(height: 24),
                  itemBuilder: (_, index) {
                    final tx = provider.transactions[index];
                    return _transactionTile(tx);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filter(String text, TransactionHistoryProvider provider) {
    final selected = provider.selectedFilter == text;
    return GestureDetector(
      onTap: () => provider.changeFilter(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: AppFontStyle.text_12_500(
            selected ? AppColors.white : AppColors.darkText,
          ),
        ),
      ),
    );
  }

  Widget _transactionTile(TransactionModel tx) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: tx.isCredit
                ? AppColors.primary.withOpacity(0.12)
                : Colors.red.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomImage(
              path: tx.isCredit
                  ? ImageConstants.downwardArrow
                  : ImageConstants.upwardArrow,
              height: 16,
              width: 16,
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
                  style: AppFontStyle.text_14_600(AppColors.darkText)),
              Text(tx.user,
                  style: AppFontStyle.text_12_400(AppColors.grey)),
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
            Text(tx.time,
                style: AppFontStyle.text_11_400(AppColors.grey)),
          ],
        ),
      ],
    );
  }
}
