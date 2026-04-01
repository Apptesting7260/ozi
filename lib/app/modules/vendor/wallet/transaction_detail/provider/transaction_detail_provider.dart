import 'package:flutter/material.dart';

import '../../model/wallet_detail_model.dart';
import '../../transaction_history/model/transaction_history_model.dart';


class TransactionDetailsProvider extends ChangeNotifier {

  final TransactionAdapter transaction;

  TransactionDetailsProvider({required this.transaction});

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  Future<void> downloadInvoice() async {
    _isDownloading = true;
    notifyListeners();
    // your download logic
    _isDownloading = false;
    notifyListeners();
  }
}

class TransactionAdapter {
  final String type;           // credit / debit
  final String amount;         // for formattedAmount
  final String createdAt;      // for _formatDate()
  final String status;         // Credit / Debit label
  final String description;    // tx.description - shown in header + row
  final String source;         // tx.source - shown in header subtitle
  final String paymentMethod;  // Payment Method row
  final String referenceId;    // Transaction Id row (reference first)
  final String id;             // Transaction Id fallback
  final String labelStyle;     // optional - skip if not needed

  TransactionAdapter({
    required this.type,
    required this.amount,
    required this.createdAt,
    required this.status,
    required this.description,
    required this.source,
    required this.paymentMethod,
    required this.referenceId,
    required this.id,
    this.labelStyle = '',
  });

  factory TransactionAdapter.fromRecent(RecentTransactions tx) {
    return TransactionAdapter(
      type:          tx.type ?? '',
      amount:        tx.amount?.toString() ?? '0',
      createdAt:     tx.createdAt ?? '',
      status:        tx.type ?? '',
      description:   tx.description ?? 'Transaction',
      source:        tx.source ?? '',
      paymentMethod: tx.paymentMethod ?? 'N/A',
      referenceId:   tx.referenceId?.toString() ?? '',
      id:            tx.id?.toString() ?? 'N/A',
    );
  }

  factory TransactionAdapter.fromHistory(TransactionHistoryData tx) {
    return TransactionAdapter(
      type:          tx.type ?? '',
      amount:        tx.amount?.toString() ?? '0',
      createdAt:     tx.createdAt ?? '',
      status:        tx.type ?? '',
      description:   tx.description ?? 'Transaction',
      source:        tx.source ?? '',
      paymentMethod: tx.paymentMethod ?? 'N/A',
      referenceId:   tx.referenceId?.toString() ?? '',
      id:            tx.id?.toString() ?? 'N/A',
    );
  }




  bool   get isCredit         => type.toLowerCase() == 'credit';
  String get formattedAmount  => '${isCredit ? '+' : '-'}\$$amount';
  String get transactionId    => referenceId.isNotEmpty ? '#$referenceId' : '#$id';
  String get statusLabel      => isCredit ? 'Credit' : 'Debit';
}