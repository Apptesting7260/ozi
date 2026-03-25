import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../model/vendor_review_model.dart';

class VendorReviewProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  VendorReviewModel? _reviews;
  VendorReviewModel? get reviewsData => _reviews;

  bool _isFetched = false;

  final filters = ["All", "5 Stars", "4 Stars", "3 Stars", "2 Stars" , "1 Stars"];

  int _selectedFilterIndex = 0;
  int get selectedFilterIndex => _selectedFilterIndex;

  void setFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }


  List<ReviewDetails> get filteredReviews {
    final allReviews = _reviews?.data?.reviewDetails ?? [];

    if (_selectedFilterIndex == 0) return allReviews;

    int selectedRating = 5 - (_selectedFilterIndex - 1);

    return allReviews
        .where((review) => review.rating == selectedRating)
        .toList();
  }

  Future<void> fetchReviews() async {
    if (_isFetched) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await Repository().fetchReviewScreen();

      _reviews = response;
      _isFetched = true;
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}