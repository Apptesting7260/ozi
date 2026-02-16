import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';

class WithdrawProvider extends ChangeNotifier {
  final Repository _repository = Repository();
  TextEditingController controller = TextEditingController();

  double balance = 3420.00;
  double selectedAmount = 20;

  final List<double> quickAmounts = [20, 30, 50, 100];

  void selectAmount(double amount) {
    selectedAmount = amount;

    controller.text = amount.toStringAsFixed(0);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    notifyListeners();
  }

  bool get canContinue {
    final amount = double.tryParse(controller.text) ?? 0;
    return amount >= 50;
  }



  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> withDrawMoney({
    required String amount,
  }
      ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _repository.withDrawMoney(amount: amount);

      return response;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
