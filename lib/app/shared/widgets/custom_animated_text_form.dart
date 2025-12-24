import '../../core/appExports/app_export.dart';
import 'custom_text_form_field.dart';

class AnimatedSearchTextField extends StatefulWidget {
  final VoidCallback? onTap;
  final List<String>? searchHints;
  final Duration typingSpeed;
  final Duration wordPause;

  const AnimatedSearchTextField({
    super.key,
    this.onTap,
    this.searchHints,
    this.typingSpeed = const Duration(milliseconds: 80),
    this.wordPause = const Duration(seconds: 1),
  });

  @override
  State<AnimatedSearchTextField> createState() =>
      _AnimatedSearchTextFieldState();
}

class _AnimatedSearchTextFieldState extends State<AnimatedSearchTextField> {
  Timer? _timer;
  int _currentWordIndex = 0;
  int _currentCharIndex = 0;
  bool _isTyping = true;
  String _displayedText = "";

  final List<String> _defaultHints = [
    'Haircut',
    'Facial',
    'Manicure',
    'Pedicure',
    'Makeup',
    'Spa',
    'Waxing',
    'Hair Color',
    'Massage',
    'Bridal Makeup',
  ];

  List<String> get hints => widget.searchHints ?? _defaultHints;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.typingSpeed, (timer) {
      if (!mounted) {
        _timer?.cancel();
        return;
      }

      final word = hints[_currentWordIndex];

      setState(() {
        if (_isTyping) {
          if (_currentCharIndex < word.length) {
            _currentCharIndex++;
            _displayedText = word.substring(0, _currentCharIndex);
          } else {
            _isTyping = false;
            _timer?.cancel();
            Future.delayed(widget.wordPause, () {
              if (mounted) {
                _startTyping();
              }
            });
          }
        } else {
          _displayedText = "";
          _currentCharIndex = 0;
          _isTyping = true;
          _currentWordIndex = (_currentWordIndex + 1) % hints.length;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onTap: widget.onTap,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 8),
        child: CustomImage(
          path: ImageConstants.search,
          width: 14,
          height: 14,
        ),
      ),
      hintText: 'Search for  "$_displayedText"',
      hintStyle: AppFontStyle.text_14_400(AppColors.hintText),
    );
  }
}
