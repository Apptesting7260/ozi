import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../auth/vendor/signup/view/pdf_file_viewer.dart';
import '../../model/wallet_detail_model.dart';
import '../../transaction_history/model/transaction_history_model.dart';


class TransactionDetailsProvider extends ChangeNotifier {

  final TransactionAdapter transaction;

  TransactionDetailsProvider({required this.transaction});

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  Future<void> downloadInvoice(BuildContext context, String bookingId) async {
    _isDownloading = true;
    notifyListeners();

    await openPdf(context, bookingId);

    _isDownloading = false;
    notifyListeners();
  }

  Map<String, Uint8List> _pdfCache = {};
  bool _isPdfLoading = false;

  bool get isPdfLoading => _isPdfLoading;



  Future<void> openPdf(BuildContext context , String bookingId) async {
    try {

      final cacheKey = "invoice_$bookingId";

      if (_pdfCache.containsKey(cacheKey)) {
        _openPdfScreen(context, _pdfCache[cacheKey]!);
        return;
      }

      _isPdfLoading = true;
      notifyListeners();

      final bytes = await Repository().downloadInvoice(bookingId);

      _pdfCache[cacheKey] = bytes;

      _isPdfLoading = false;
      notifyListeners();

      _openPdfScreen(context, bytes);
    } catch (e) {
      _isPdfLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print("❌ PDF ERROR: $e");
      }
    }
  }

  void _openPdfScreen(BuildContext context, Uint8List bytes) async{

  await  downloadPdf(context, bytes);
  }



  Future<void> downloadPdf(BuildContext context,Uint8List bytes) async {
    try {
      String filePath = '';

      if (Platform.isAndroid) {
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          filePath = '${downloadsDir.path}/document_${DateTime.now().millisecondsSinceEpoch}.pdf';
        } else {
          final extDir = await getExternalStorageDirectory();
          if (extDir == null) throw Exception('No storage directory found');
          filePath = '${extDir.path}/document_${DateTime.now().millisecondsSinceEpoch}.pdf';
        }
      } else if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        filePath = '${dir.path}/document_${DateTime.now().millisecondsSinceEpoch}.pdf';
      }

      debugPrint('💾 Saving PDF to: $filePath');

      await File(filePath).writeAsBytes(bytes, flush: true);

      debugPrint('✅ PDF saved successfully: $filePath');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved: ${filePath.split('/').last}'),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'OPEN',
              textColor: Colors.yellow,
              onPressed: () async {
                final result = await OpenFilex.open(
                  filePath,
                  type: 'application/pdf',
                );
                debugPrint('📂 Open result: ${result.message}');
              },
            ),
          ),
        );
      }
    } catch (e, stack) {
      debugPrint('❌ PDF DOWNLOAD ERROR: $e');
      debugPrint('📋 STACK: $stack');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    }
  }
}

class TransactionAdapter {
  final String bookingId;
  final String type;           // credit / debit
  final String amount;         // for formattedAmount
  final String createdAt;      // for _formatDate()
  final String status;         // Credit / Debit label
  final String description;    // tx.description - shown in header + row
  final String source;
  final String serviceName;
  final String customerName;
  final String paymentMethod;  // Payment Method row
  final String referenceId;    // Transaction Id row (reference first)
  final String id;             // Transaction Id fallback
  final String labelStyle;     // optional - skip if not needed

  TransactionAdapter({
    required this.bookingId,
    required this.type,
    required this.amount,
    required this.createdAt,
    required this.status,
    required this.description,
    required this.source,
    required this.serviceName,
    required this.customerName,
    required this.paymentMethod,
    required this.referenceId,
    required this.id,
    this.labelStyle = '',
  });

  factory TransactionAdapter.fromRecent(RecentTransactions tx) {
    return TransactionAdapter(
      bookingId:     tx.bookingId?.toString() ?? 'N/A',
      type:          tx.type ?? '',
      amount:        tx.amount?.toString() ?? '0',
      createdAt:     tx.createdAt ?? '',
      status:        tx.type ?? '',
      description:   tx.description ?? 'Transaction',
      source:        tx.source ?? '',
      serviceName:   tx.serviceName ?? '',
      customerName:  tx.customerName ?? '',
      paymentMethod: tx.paymentMethod ?? 'N/A',
      referenceId:   tx.referenceId?.toString() ?? '',
      id:            tx.id?.toString() ?? 'N/A',
    );
  }

  factory TransactionAdapter.fromHistory(TransactionHistoryData tx) {
    return TransactionAdapter(
      bookingId:     tx.bookingId?.toString() ?? 'N/A',
      type:          tx.type ?? '',
      amount:        tx.amount?.toString() ?? '0',
      createdAt:     tx.createdAt ?? '',
      status:        tx.type ?? '',
      description:   tx.description ?? 'Transaction',
      source:        tx.source ?? '',
      serviceName:   tx.serviceName ?? '',
      customerName:  tx.customerName ?? '',
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