import '../../core/appExports/app_export.dart';

class CircularProfileImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color borderColor;

  const CircularProfileImage({
    super.key,
    required this.imageUrl,
    this.size = 64,
    this.borderColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: CustomImage(
          shimmerChild: Container(color: Colors.grey),
          path: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}