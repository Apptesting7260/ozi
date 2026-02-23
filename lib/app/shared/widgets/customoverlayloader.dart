import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class CustomOverlayLoader {
  /// Show loader
  static void show(BuildContext context) {
    Loader.show(
      context,
      isSafeAreaOverlay: false,
      isBottomBarOverlay: false,
      overlayFromBottom: 0,
      overlayColor: Colors.black26,
      progressIndicator: const CircularProgressIndicator(
        backgroundColor: Colors.red,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
      themeData: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green),
      ),
    );
  }

  /// Hide loader
  static void hide() {
    Loader.hide();
  }
}
