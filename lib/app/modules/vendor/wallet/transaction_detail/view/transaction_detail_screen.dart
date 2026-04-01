import 'package:flutter/material.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:ozi/app/modules/vendor/wallet/model/wallet_detail_model.dart';
import '../provider/transaction_detail_provider.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tx = ModalRoute.of(context)!.settings.arguments as TransactionAdapter;

    return ChangeNotifierProvider(
      create: (_) => TransactionDetailsProvider(transaction: tx),
      child: Consumer<TransactionDetailsProvider>(
        builder: (context, provider, _) {
          final tx = provider.transaction;
          final bool isCredit = tx.type?.toLowerCase() == 'credit';

          return Scaffold(
            backgroundColor: const Color(0xFFF2F2F7),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: CustomAppBar(title: "Transaction Details"),
                  ),

                  const SizedBox(height: 48),


                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildCard(context, tx, isCredit, provider),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildCard(
      BuildContext context,
       tx,
      bool isCredit,
      TransactionDetailsProvider provider,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chatTextFieldColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(tx, isCredit),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Color(0xFFF2F2F7)),
          ),
          _buildRows(tx, isCredit,context,provider),

        ],
      ),
    );
  }

  Widget _buildHeader( tx, bool isCredit) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFEBEE),
              shape: BoxShape.circle
            ),
            child: Icon(
              isCredit ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: isCredit
                  ? const Color(0xFF2ECC71)
                  : const Color(0xFFFF3B30),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description ?? 'Transaction',
                style: AppFontStyle.text_16_500(
                    AppColors.chatAppBarTextColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  tx.source ?? '',
                  style: AppFontStyle.text_14_400(
                      AppColors.chatAppBarMenuIconColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRows( tx, bool isCredit , context,provider) {
    final String formattedAmount =
        '${isCredit ? '+' : '-'}\$${tx.amount ?? '0'}';
    final String formattedDate = _formatDate(tx.createdAt);
    final Color _ =
    isCredit ? const Color(0xFF2ECC71) : const Color(0xFFFF3B30);

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Card(
       // color: AppColors.chatTextFieldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _DetailRow(
                label: tx.description ?? 'N/A',
                labelStyle: AppFontStyle.text_16_500(
                    AppColors.chatAppBarTextColor),
                value: tx.source ?? '',
                valueStyle: AppFontStyle.text_14_400(
                    AppColors.chatAppBarMenuIconColor),
                isNameRow: true,
              ),
              _DetailRow(
                label: 'Amount',
                value: formattedAmount,
                labelStyle: AppFontStyle.text_14_400(
                    AppColors.chatAppBarMenuIconColor),
                valueStyle: AppFontStyle.text_16_600(
                    AppColors.chatSenderColor),
              ),
              _DetailRow(
                label: 'Payment Method',
                labelStyle: AppFontStyle.text_14_400(
                    AppColors.chatAppBarMenuIconColor),
                value: tx.paymentMethod ?? 'N/A',
                valueStyle: AppFontStyle.text_16_300(
                    AppColors.chatAppBarMenuIconColor),
              ),
              _DetailRow(
                label: 'Transaction Id',
                labelStyle: AppFontStyle.text_14_400(
                    AppColors.chatAppBarMenuIconColor),
                value: tx.referenceId != null
                    ? '#${tx.referenceId}'
                    : '#${tx.id ?? 'N/A'}',
                valueStyle: AppFontStyle.text_16_300(
                    AppColors.chatAppBarMenuIconColor),
              ),
              _DetailRow(
                label: 'Date & Time',
                labelStyle: AppFontStyle.text_14_400(
                    AppColors.chatAppBarMenuIconColor),
                value: formattedDate,
                valueStyle: AppFontStyle.text_16_300(
                    AppColors.chatAppBarMenuIconColor),
              ),
              _DetailRow(
                label: 'Status',
                value: isCredit ? 'Credit' : 'Debit',
                valueStyle: AppFontStyle.text_16_500(
                    AppColors.chatSenderColor),
                isLast: true,
              ),


              _buildDownloadButton(context, provider),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final now = DateTime.now();
      final isToday = dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day;

      final hour =
      dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final timeStr = '$hour:$minute $period';

      if (isToday) return 'Today, $timeStr';

      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}, $timeStr';
    } catch (_) {
      return raw;
    }
  }

  Widget _buildDownloadButton(
      BuildContext context, TransactionDetailsProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: SizedBox(
        width: 310,
        height: 50,
        child: ElevatedButton(
          onPressed:
          provider.isDownloading ? null : provider.downloadInvoice,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.chatSenderColor,
            disabledBackgroundColor:
            const Color(0xFF2ECC71).withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            elevation: 0,
          ),
          child: provider.isDownloading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageConstants.downloadIcon,width: 20,height: 20,),
              const SizedBox(width: 10),
              Text(
                'Download Invoice',
                style:  AppFontStyle.text_16_600(
                    AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final bool isLast;
  final bool isNameRow;

  const _DetailRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.isLast = false,
    this.isNameRow = false,
  });

  @override
  Widget build(BuildContext context) {
    const defaultValueStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xFF3C3C43),
    );

    if (isNameRow) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: labelStyle),
            const SizedBox(height: 2),
            Text(value, style: valueStyle ?? defaultValueStyle),
            const SizedBox(height: 14),
             Divider(height: 1, color: AppColors.dividerColor ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: labelStyle ??
                    const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF8E8E93),
                      fontWeight: FontWeight.w400,
                    ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: valueStyle ?? defaultValueStyle,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)  Divider(height: 1, color: AppColors.dividerColor ),
      ],
    );
  }
}