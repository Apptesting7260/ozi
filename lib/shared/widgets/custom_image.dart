import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/appExports/app_export.dart';

class CustomImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final double scale;
  final Widget? shimmerChild;
  final Color? color;
  final Widget Function(BuildContext, String, Object)? errorWidget;

  const CustomImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.scale = 1.0,
    this.errorWidget,
    this.shimmerChild,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: borderRadius, child: _getImageWidget());
  }

  Widget _getImageWidget() {
    if (path.isEmpty) {
      return _errorPlaceholder();
    }

    if (_isNetworkImage(path)) {
      return _loadNetworkImage(path);
    } else if (_isAssetImage(path)) {
      return _loadAssetImage(path);
    } else if (_isFileImage(path)) {
      return _loadFileImage(path);
    } else {
      return _errorPlaceholder();
    }
  }

  Widget _loadNetworkImage(String url) {
    return _isSvg(url)
        ? SvgPicture.network(
            url,
            width: width,
            height: height,
      fit: fit,
            placeholderBuilder: (context) => _loading(),
          )
        : CachedNetworkImage(
            memCacheWidth: 500,
            memCacheHeight: 500,
            imageUrl: url,
            width: width,
            height: height,
            fit: fit,
            scale: scale,
            errorWidget:
                errorWidget ?? (context, url, error) => _errorPlaceholder(),
            placeholder: (context, url) => _loading(),
          );
  }

  Widget _loadAssetImage(String path) {
    return _isSvg(path)
        ? SvgPicture.asset(
            path,
            width: width,
            height: height,
      fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (context) => _loading(),
          )
        : Image.asset(
            color: color,
            path,
            width: width,
            height: height,
            fit: fit,
            scale: scale,
            errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
          );
  }

  Widget _loadFileImage(String path) {
    return _isSvg(path)
        ? SvgPicture.file(
            File(path),
            width: width,
            height: height,
      fit: fit,
            placeholderBuilder: (context) => _loading(),
          )
        : Image.file(
            File(path),
            width: width,
            height: height,
            fit: fit,
            scale: scale,
            errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
          );
  }

  bool _isNetworkImage(String path) {
    return path.startsWith("http") || path.startsWith("https");
  }

  bool _isAssetImage(String path) {
    return path.startsWith("assets/");
  }

  bool _isFileImage(String path) {
    return File(path).existsSync();
  }

  bool _isSvg(String path) {
    return path.toLowerCase().endsWith(".svg");
  }

  Widget _errorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.grey,
      child: Icon(Icons.broken_image, color: AppColors.grey),
    );
  }

  Widget _loading() {
    return Shimmer.fromColors(
      baseColor: AppColors.grey.withValues(alpha: 0.4),
      highlightColor: AppColors.grey,
      child: shimmerChild ?? const SizedBox(),
    );
  }
}
