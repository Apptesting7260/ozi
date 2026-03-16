import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/playstore.png');
  final original = img.decodeImage(file.readAsBytesSync());
  
  if (original == null) {
    print('Failed to decode image');
    return;
  }
  
  // We make the canvas 1.8x larger to add transparent padding around the original image.
  // This effectively scales down the logo on the splash screen and prevents cropping.
  final paddingFactor = 1.8;
  final newWidth = (original.width * paddingFactor).toInt();
  final newHeight = (original.height * paddingFactor).toInt();
  
  // Create transparent canvas
  final canvas = img.Image(width: newWidth, height: newHeight, numChannels: 4);
  
  final dstX = (newWidth - original.width) ~/ 2;
  final dstY = (newHeight - original.height) ~/ 2;
  
  // Draw the original image onto the center of the transparent canvas
  img.compositeImage(canvas, original, dstX: dstX, dstY: dstY);
  
  final outPath = 'assets/images/playstore_splash.png';
  File(outPath).writeAsBytesSync(img.encodePng(canvas));
  print('Successfully created $outPath');
}
