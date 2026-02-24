import '../../core/appExports/app_export.dart';

class ImagePathHelper {
  static String getFullImageUrl(String? path, String imageBaseUrl) {
    if (path == null || path.isEmpty) return "";

    // If already a complete URL
    if (path.startsWith("http")) return path;

    // Combine base URL + relative path
    if (kDebugMode) {
      print("Image Path: $path");
    }
    if (kDebugMode) {
      print("Full Image URL: $imageBaseUrl$path");
    }
    return "$imageBaseUrl$path";
  }
}
