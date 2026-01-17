class ImagePathHelper {
  static String getFullImageUrl(String? path, String imageBaseUrl) {
    if (path == null || path.isEmpty) return "";

    // If already a complete URL
    if (path.startsWith("http")) return path;

    // Combine base URL + relative path
    print("Full Image URL: $imageBaseUrl$path");
    return "$imageBaseUrl$path";

  }
}
