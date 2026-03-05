import '../../core/appExports/app_export.dart';

class CircularProfileImage extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color borderColor;

  const CircularProfileImage({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 64,
    this.borderColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: hasImage
            ? CustomImage(
          shimmerChild: Container(color: Colors.grey),
          path: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        )
            : Container(
          color: AppColors.primary.withOpacity(0.15),
          alignment: Alignment.center,
          child: Text(
            _getInitials(name),
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) {
      return '?';
    }

    List<String> parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}