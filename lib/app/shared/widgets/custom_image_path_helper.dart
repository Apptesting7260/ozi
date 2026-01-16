class ImagePathHelper {
  static String getFullImageUrl(String? path, String baseUrl) {
    if (path == null || path.isEmpty) return "";

    // If already a complete URL
    if (path.startsWith("http")) return path;

    // Combine base URL + relative path
    return "$baseUrl$path";
  }
}
