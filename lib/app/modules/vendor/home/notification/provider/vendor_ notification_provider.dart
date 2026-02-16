import 'package:ozi/app/data/repository/repository.dart';
import '../../../../../core/appExports/app_export.dart';
import '../model/get_notification_model.dart';

class VendorNotificationProvider extends ChangeNotifier {

  final Repository _repository = Repository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GetNotificationModel? _getNotificationModel;
  GetNotificationModel? get getNotificationModel => _getNotificationModel;

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  VendorNotificationProvider() {
    getNotifications();
  }

  Future<void> getNotifications() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _repository.fetchNotifications();

      _getNotificationModel = response;

      _notifications = response.data?.data ?? [];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _notifications = [];
      notifyListeners();
    }
  }


  void markAsRead(int index) {
    if (index < _notifications.length) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }
}
