import 'package:flutter/material.dart';
import '../model/reviewmodel.dart';

class ReviewsProvider extends ChangeNotifier {
  List<ReviewModel> _reviews = [
    ReviewModel(
      userName: "Dora Perry",
      userImage: "https://randomuser.me/api/portraits/men/1.jpg",
      rating: 4.0,
      date: "Today, 09:12",
      reviewText:
          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley.",
    ),
    ReviewModel(
      userName: "Dora Perry",
      userImage: "https://randomuser.me/api/portraits/men/1.jpg",
      rating: 4.0,
      date: "Today, 09:12",
      reviewText:
          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley.",
    ),
    ReviewModel(
      userName: "Dora Perry",
      userImage: "https://randomuser.me/api/portraits/men/1.jpg",
      rating: 4.0,
      date: "Today, 09:12",
      reviewText:
          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley.",
    ),
    ReviewModel(
      userName: "Dora Perry",
      userImage: "https://randomuser.me/api/portraits/men/1.jpg",
      rating: 4.0,
      date: "Today, 09:12",
      reviewText:
          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley.",
    ),
  ];

  List<ReviewModel> get reviews => _reviews;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchReviews() async {
    // This will be replaced with actual API call later
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }
}
