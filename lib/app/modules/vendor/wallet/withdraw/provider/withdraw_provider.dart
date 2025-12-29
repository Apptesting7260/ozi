import '../../../../../core/appExports/app_export.dart';

class WithdrawProvider extends ChangeNotifier {
  double balance = 3420.00;
  double selectedAmount = 20;

  final List<double> quickAmounts = [20, 30, 50, 100];

  void selectAmount(double amount) {
    selectedAmount = amount;
    notifyListeners();
  }

  bool get canContinue => selectedAmount >= 50;
}
