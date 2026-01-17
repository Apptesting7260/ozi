import '../../../../core/appExports/app_export.dart';
import '../../../../data/repository/repository.dart';
import '../model/category_model.dart';
import '../services/view/CategoryDetailScreen.dart';

class HomeScreenProvider extends ChangeNotifier {
  String _selectedLocation = "Select Location";
  final String _userName = "Alex";

  bool _isLoaded = false;
  bool _isLoading = false;

  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  String get selectedLocation => _selectedLocation;
  String get userName => _userName;

  final List<Data> _serviceCategories = [];
  List<Data> get serviceCategories => _serviceCategories;

  final Repository _repository = Repository();

  Future<void> loadOnce() async {
    if (_isLoaded) return;

    _isLoading = true;
    notifyListeners();

    await _fetchCategories();

    _isLoaded = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchCategories() async {
    try {
      final CategoryModel model =
      await _repository.homePageCategoryApi({});

      _serviceCategories.clear();

      if (model.status == true && model.data != null && model.data!.isNotEmpty) {
        _serviceCategories.addAll(model.data!);
      }

    } catch (e) {
      debugPrint("❌ Category API Error: $e");
    }
  }



  void updateLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void onCategoryTap(Data category, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(
          category: category,
        ),
      ),
    );
  }
  Future<void> refreshData() async {
    await _fetchCategories();
  }

  void onBecomeProviderTap(BuildContext context) {}
  void onLocationTap(BuildContext context) {}
  void onProfileTap(BuildContext context) {}
  void onSearchTap(BuildContext context) {}
}
