import 'package:geolocator/geolocator.dart';
import '../appExports/app_export.dart';

class LocationPermissionHelper {
  static Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        showLocationPermissionDialog(
          context,
          "Location services are disabled. Please enable them to continue.",
        );
      }
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          showLocationPermissionDialog(
            context,
            "Location permission is required to find your address. Please enable it.",
          );
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        showLocationPermissionDialog(
          context,
          "Location permissions are permanently denied, we cannot request permissions. Please enable them in settings.",
        );
      }
      return false;
    }

    return true;
  }

  static void showLocationPermissionDialog(
    BuildContext context,
    String message,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.location_off,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Location Permission",
                  style: AppFontStyle.text_18_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  maxLines: 3,
                  style: AppFontStyle.text_14_400(AppColors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Enable Location",
                  borderRadius: BorderRadius.circular(30),
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await Geolocator.openAppSettings();
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: "Cancel",
                  isOutlined: true,
                  borderRadius: BorderRadius.circular(30),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
