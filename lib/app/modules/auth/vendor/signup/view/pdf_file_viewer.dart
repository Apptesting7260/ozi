import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../../core/appExports/app_export.dart';
import '../provider/pdf_file_provider.dart';

class PdfViewScreen extends StatelessWidget {
  final Uint8List bytes;

  const PdfViewScreen({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PdfViewerProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("PDF View"),
        ),
        body: Consumer<PdfViewerProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [

                SfPdfViewer.memory(
                  bytes,
                  controller: provider.controller,

                  enableDoubleTapZooming: true,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,

                  onDocumentLoaded: (details) {
                    provider.onDocumentLoaded(
                      details.document.pages.count,
                    );
                  },

                  onPageChanged: (details) {
                    provider.onPageChanged(
                      details.newPageNumber,
                    );
                  },

                  onDocumentLoadFailed: (details) {
                    provider.onError();
                  },
                ),

                if (!provider.isLoaded)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                if (provider.isLoaded)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${provider.currentPage} / ${provider.totalPages}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}




// Image are to see full image from Identity Verification screen

class FullImageViewScreen extends StatelessWidget {
  final String imageUrl;

  const FullImageViewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageViewerProvider(),
      child: Consumer<ImageViewerProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: Colors.black,

            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),

            body: Stack(
              children: [


                SizedBox.expand(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    child: Center(
                      child: GestureDetector(
                        onDoubleTap: () {

                        },
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,


                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (frame != null || wasSynchronouslyLoaded) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) {
                                if (context.mounted) {
                                  context
                                      .read<ImageViewerProvider>()
                                      .setLoaded();
                                }
                              });
                            }
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: provider.isLoading ? 0 : 1,
                              child: child,
                            );
                          },
                          errorBuilder: (_, __, ___) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) {
                              if (context.mounted) {
                                context
                                    .read<ImageViewerProvider>()
                                    .setLoaded();
                              }
                            });

                            return const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.broken_image,
                                      color: Colors.white, size: 40),
                                  SizedBox(height: 8),
                                  Text(
                                    "Failed to load image",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),


                if (provider.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}