import '../../../../core/appExports/app_export.dart';

class WalletProvider extends ChangeNotifier {
  /// ================= STATE =================
  double availableBalance = 0.0;
  double todayEarning = 0.0;
  double weeklyEarning = 0.0;

  bool isLoading = false;

  List<WalletTransaction> transactions = [];

  /// ================= INIT =================
  WalletProvider() {
    fetchWalletData();
  }

  /// ================= API CALL (DUMMY NOW) =================
  Future<void> fetchWalletData() async {
    isLoading = true;
    notifyListeners();

    // 🔹 Replace this with API later
    await Future.delayed(const Duration(seconds: 1));

    availableBalance = 3420.00;
    todayEarning = 248.50;
    weeklyEarning = 5680;

    transactions = [
      WalletTransaction(
        title: "Deep Cleaning",
        user: "John Doe",
        amount: 120,
        isCredit: true,
        time: "Today, 4:00 PM",
      ),
      WalletTransaction(
        title: "Deep Cleaning",
        user: "Mike Chen",
        amount: 85,
        isCredit: true,
        time: "Yesterday, 6:30 PM",
      ),
      WalletTransaction(
        title: "Withdrawal",
        user: "Bank Transfer",
        amount: 500,
        isCredit: false,
        time: "Dec 15, 6:30 PM",
      ),
      WalletTransaction(
        title: "Plumbing Fix",
        user: "Emma Wilson",
        amount: 150,
        isCredit: true,
        time: "Dec 14, 6:30 PM",
      ),
    ];

    isLoading = false;
    notifyListeners();
  }

  /// ================= ACTIONS =================
  void withdraw() {
    // call withdraw API later
  }
}

/// ================= MODEL =================
class WalletTransaction {
  final String title;
  final String user;
  final double amount;
  final bool isCredit;
  final String time;

  WalletTransaction({
    required this.title,
    required this.user,
    required this.amount,
    required this.isCredit,
    required this.time,
  });
}
