import 'package:flutter/material.dart';
import 'package:ozi/app/core/utils/get_utils.dart';
import '../../../../data/repository/repository.dart';
import '../model/reviewmodel.dart';

class ReviewsProvider extends ChangeNotifier {
  final Repository _repository = Repository();
  getVendorReviewsModel? _vendorReviews;
  List<Data> _reviews = [];

  List<Data> get reviews => _reviews;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadMore = false;
  bool get isLoadMore => _isLoadMore;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool get hasNextPage => _hasNextPage;

  Future<void> fetchReviews(String vendorId, {bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!_hasNextPage || _isLoadMore) return;
      _isLoadMore = true;
    } else {
      _isLoading = true;
      _reviews = [];
      _currentPage = 1;
      _hasNextPage = true;
    }
    notifyListeners();

    try {
      _vendorReviews = await _repository.getvendorReviewApi(
        vendorId,
        page: _currentPage,
      );
      if (_vendorReviews != null && _vendorReviews!.data != null) {
        if (isLoadMore) {
          _reviews.addAll(_vendorReviews!.data!);
        } else {
          _reviews = _vendorReviews!.data!;
        }

        if (_vendorReviews!.meta != null) {
          _currentPage++;
          _hasNextPage =
              _vendorReviews!.meta!.currentPage! <
              _vendorReviews!.meta!.lastPage!;
        } else {
          _hasNextPage = false;
        }
      }
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      Get.showToast(
        e.toString(),
        type: ToastType.error,
      );
    } finally {
      if (isLoadMore) {
        _isLoadMore = false;
      } else {
        _isLoading = false;
      }
      notifyListeners();
    }
  }
}
