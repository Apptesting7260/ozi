import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/models/all_services_model_vendor.dart';

class FilterProvider extends ChangeNotifier {
  bool? active;

  final List<ServiceCategory> allCategories;
  bool isLoading = true;

  final Set<ServiceCategory> selectedCategories = {};

  FilterProvider(
      List<ServiceCategory> categories, {
        bool? initialStatus,
        String? initialCategoryId,
      }) : allCategories = categories {
    active = initialStatus;

    if (initialCategoryId != null) {
      final match = categories.firstWhere(
            (c) => c.id.toString() == initialCategoryId,
        orElse: () => ServiceCategory(),
      );

      if (match.id != null) {
        selectedCategories.add(match);
      }
    }

    _init();
  }


  void _init() async {
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
    notifyListeners();
  }

  void selectStatus(bool value) {
    active = value;
    notifyListeners();
  }

  void toggleCategory(ServiceCategory category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.clear(); // single select
      selectedCategories.add(category);
    }
    notifyListeners();
  }

  void clearAll() {
    active = null;
    selectedCategories.clear();
    notifyListeners();
  }

  bool get canApply =>
      active != null || selectedCategories.isNotEmpty;
}

class ServiceFilter {
  bool? status;
  int? categoryId;

  ServiceFilter({this.status, this.categoryId});

  bool get isEmpty => status == null && categoryId == null;
}


