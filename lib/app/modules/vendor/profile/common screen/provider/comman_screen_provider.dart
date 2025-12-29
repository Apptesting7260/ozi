import '../../../../../core/appExports/app_export.dart';

class CommonDrawerProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
class CommonScreenArgs {
  final String type;
  final String url;
  CommonScreenArgs({required this.type, required this.url});
}

