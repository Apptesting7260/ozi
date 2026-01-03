
import 'package:flutter/material.dart';
import '../../../core/constants/image_constant.dart';

class WelcomeProvider extends ChangeNotifier {
  int _currentPage = 0;

  final PageController _pageController = PageController();

  int get currentPage => _currentPage;
  PageController get pageController => _pageController;

  final List<SlideData> slides = [
    SlideData(
      heading: "All Your Home Services, \nJust a Tap Away",
      subheading: "Book any home service from the comfort of your home – from repairs to cleaning, we bring professionals right to your doorstep.",
      imagePath: ImageConstants.onboard1,
    ),
    SlideData(
      heading: "Schedule Your Service in \nJust a Few Simple Steps",
      subheading: "Select a trusted professional and schedule your service in just a few taps. No waiting, no hassle.",
      imagePath: ImageConstants.onboard2,
    ),
    SlideData(
      heading: "Verified Experts You Can \nRely On Every Time",
      subheading: "Every service provider is carefully verified. Enjoy top-quality service with peace of mind.",
      imagePath: ImageConstants.onboard3,
    ),
  ];

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {

    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class SlideData {
  final String heading;
  final String subheading;
  final String imagePath;

  SlideData({
    required this.heading,
    required this.subheading,
    required this.imagePath,
  });
}