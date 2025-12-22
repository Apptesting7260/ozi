import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/appExports/app_export.dart';
import '../provider/comman_screen_provider.dart';

class CommonScreen extends StatefulWidget {
  final String type;
  final String url;

  const CommonScreen({super.key, required this.type, required this.url});

  @override
  State<CommonScreen> createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  late final WebViewController _controller;
  final CommonDrawerProvider _provider = CommonDrawerProvider();

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            _provider.setLoading(true);
          },
          onPageFinished: (_) {
            _provider.setLoading(false);
          },
          onWebResourceError: (_) {
            _provider.setLoading(false);
          },
        ),
      )
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false);

    if (widget.url.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.loadRequest(Uri.parse(widget.url));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider, // ✅ pass the instance
      child: Consumer<CommonDrawerProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    CustomAppBar(title: widget.type),
                    Expanded(child: WebViewWidget(controller: _controller)),
                  ],
                ),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
