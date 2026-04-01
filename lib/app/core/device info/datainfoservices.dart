import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const _storage = FlutterSecureStorage();
  static const _key = 'permanent_device_id';
  static final _deviceInfo = DeviceInfoPlugin();

  /// Returns a unique ID for the device (Android SSAID or iOS Keychain UUID)
  static Future<String> getFinalUniqueId() async {
    String? deviceId;

    try {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        deviceId = await androidIdPlugin.getId();
      } else if (Platform.isIOS) {
        deviceId = await _storage.read(key: _key);

        if (deviceId == null) {
          final iosInfo = await _deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor ?? const Uuid().v4();

          await _storage.write(
            key: _key,
            value: deviceId,
            iOptions: const IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );
        }
      }
    } catch (e) {
      deviceId = "unknown_${DateTime.now().millisecondsSinceEpoch}";
    }

    return deviceId ?? "unknown_id";
  }

  /// Returns a human-readable device name (e.g., "Samsung SM-G991B" or "John's iPhone")
  static Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Combines Brand and Model for a clear name
        return "${androidInfo.brand} ${androidInfo.model}";
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // On iOS, .name returns the user-defined name like "Alex's iPhone"
        return iosInfo.name;
      }
    } catch (e) {
      return "Unknown Device";
    }
    return "Unknown Platform";
  }
}