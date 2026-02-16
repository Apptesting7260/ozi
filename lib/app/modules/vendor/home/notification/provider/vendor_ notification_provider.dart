import 'package:ozi/app/data/repository/repository.dart';
import '../../../../../core/appExports/app_export.dart';
import '../model/get_notification_model.dart';

class VendorNotificationProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  bool _isReadLoading = false;
  bool get isReadLoading => _isReadLoading;

  int _currentPage = 1;
  int _lastPage = 1;
  bool _hasMore = true;

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  VendorNotificationProvider() {
    getNotifications();
  }

  // ================= FETCH FIRST PAGE =================
  Future<void> getNotifications({bool isRefresh = false}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;

      if (isRefresh) {
        _currentPage = 1;
        _notifications.clear();
        _hasMore = true;
      }

      notifyListeners();

      final response =
      await _repository.fetchNotifications(page: _currentPage);

      _notifications = response.data?.data ?? [];
      _currentPage = response.data?.currentPage ?? 1;
      _lastPage = response.data?.lastPage ?? 1;

      _hasMore = _currentPage < _lastPage;
    } catch (e) {
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= LOAD MORE =================
  Future<void> loadMore() async {
    if (!_hasMore || _isPaginationLoading) return;

    try {
      _isPaginationLoading = true;
      notifyListeners();

      _currentPage++;

      final response =
      await _repository.fetchNotifications(page: _currentPage);

      final newData = response.data?.data ?? [];

      _notifications.addAll(newData);

      _hasMore = _currentPage < (response.data?.lastPage ?? 1);
    } catch (e) {
      _currentPage--;
    } finally {
      _isPaginationLoading = false;
      notifyListeners();
    }
  }

  // ================= MARK ALL READ =================
  Future<void> readNotifications() async {
    try {
      _isReadLoading = true;
      notifyListeners();

      final response = await _repository.readAllNotifications();

      if (response.status == true) {
        for (var item in _notifications) {
          item.isRead = true;
        }
      }
    } finally {
      _isReadLoading = false;
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

