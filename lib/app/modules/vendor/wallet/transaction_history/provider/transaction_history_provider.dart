import 'package:ozi/app/data/repository/repository.dart';
import '../../../../../core/appExports/app_export.dart';
import '../model/transaction_history_model.dart';


class TransactionHistoryProvider extends ChangeNotifier {

  final Repository _repository = Repository();

  // ---------------- VARIABLES ----------------

  List<TransactionHistoryData> transactions = [];
  TransactionHistoryPagination? pagination;

  String selectedFilter = "All";
  String searchQuery = "";

  bool _loading = false;
  bool get loading => _loading;

  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  // ---------------- FETCH ----------------

  Future<void> fetchTransactions({bool isLoadMore = false}) async {

    if (isLoadMore) {
      if (_isLoadingMore || pagination?.hasMore != true) return;
      _isLoadingMore = true;
    } else {
      _loading = true;
      _currentPage = 1;
      pagination = null;
      transactions.clear();
    }

    notifyListeners();

    try {
      final response = await _repository.fetchTransactionsHistory(
        search: searchQuery,
        limit: 10,
        period: _mapFilterToPeriod(selectedFilter),
        page: _currentPage,
      );

      if (response.data != null) {
        transactions.addAll(response.data!);
      }

      pagination = response.pagination;

      if (pagination?.hasMore == true) {
        _currentPage++;
      }

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    _loading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  // ---------------- FILTER ----------------

  void changeFilter(String filter) {
    selectedFilter = filter;
    fetchTransactions();
  }

  String? _mapFilterToPeriod(String filter) {
    switch (filter) {
      case "This Month":
        return "this_month";
      case "Last 6 Months":
        return "last_6_months";
      default:
        return null;
    }
  }

  // ---------------- SEARCH ----------------

  void updateSearch(String value) {
    searchQuery = value;
    fetchTransactions();
  }
}
