import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../model/helpsupportmodel.dart';

class HelpVendorProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  int _tabIndex = 0;
  int _expandedIndex = -1;
  helpSupportModel? _helpModel;
  bool _isLoading = false;

  int get tabIndex => _tabIndex;
  int get expandedIndex => _expandedIndex;
  helpSupportModel? get helpModel => _helpModel;
  bool get isLoading => _isLoading;

  void changeTab(int index) {
    _tabIndex = index;
    _expandedIndex = -1;
    notifyListeners();
  }

  void toggleExpanded(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = -1;
    } else {
      _expandedIndex = index;
    }
    notifyListeners();
  }

  Future<void> fetchHelpData(String type) async {
    _isLoading = true;
    _helpModel = null;
    notifyListeners();

    try {
      final result = await _repository.helpCenterApi(type);
      if (result.status?.toLowerCase() == "success") {
        _helpModel = result;
      }
    } catch (e) {
      debugPrint("Error fetching help data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendSupportMessage({
    required String email,
    required String subject,
    required String message,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();
    if (kDebugMode) {
      print("Sending support message with data: $email, $subject, $message");
    }
    try {
      var data = {"email": email, "subject": subject, "message": message};

      final response = await _repository.supportApi(data);
      if (kDebugMode) {
        print("data we are sending in api :$data");
      }
      if (response['status']?.toLowerCase() == "success" ||
          response['status'] == "1") {
        onSuccess(response['message'] ?? "Message sent successfully");
      } else {
        onError(response['message'] ?? "Failed to send message");
      }
    } catch (e) {
      debugPrint("Error sending support message: $e");
      onError("An error occurred. Please try again.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
