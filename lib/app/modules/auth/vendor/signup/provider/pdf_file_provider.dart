import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../core/appExports/app_export.dart';

class PdfViewerProvider extends ChangeNotifier {
  final PdfViewerController controller = PdfViewerController();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  int _totalPages = 0;
  int get totalPages => _totalPages;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  void onDocumentLoaded(int total) {
    _totalPages = total;
    _isLoaded = true;
    notifyListeners();
  }

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void onError() {
    Get.showToast("Failed to load PDF", type: ToastType.error);
  }
}




 // Here Full image provider

class ImageViewerProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isZoomed = false;
  bool get isZoomed => _isZoomed;

  void setLoaded() {
    if (!_isLoading) return;
    _isLoading = false;
    notifyListeners();
  }

  void onInteractionUpdate(ScaleUpdateDetails details) {
    final zoomed = details.scale > 1.01;

    if (_isZoomed != zoomed) {
      _isZoomed = zoomed;
      notifyListeners();
    }
  }


}