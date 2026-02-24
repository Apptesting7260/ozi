import '../../core/appExports/app_export.dart';

class ReadMoreDescription extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int trimLines;

  const ReadMoreDescription({
    super.key,
    required this.text,
    required this.style,
    this.trimLines = 2,
  });

  @override
  State<ReadMoreDescription> createState() => _ReadMoreDescriptionState();
}

class _ReadMoreDescriptionState extends State<ReadMoreDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: widget.style);
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        if (tp.didExceedMaxLines) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style: widget.style,
                maxLines: isExpanded ? null : widget.trimLines,
                overflow: isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    isExpanded ? "Read Less" : "Read More",
                    style: widget.style.copyWith(
                      color: AppColors.primary,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Text(widget.text, style: widget.style);
        }
      },
    );
  }
}
