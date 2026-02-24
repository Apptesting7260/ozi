import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const _deviceIdKey = 'unique_device_id';
  static const _deviceNameKey = 'unique_device_name';
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if already stored
    String? storedId = prefs.getString(_deviceIdKey);
    if (storedId != null) {
      return storedId;
    }

    String newId;

    // Try to get a device-specific ID (fallback to random UUID)
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      newId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      newId = iosInfo.identifierForVendor ?? const Uuid().v4();
    } else {
      newId = const Uuid().v4();
    }

    // Save for persistence
    await prefs.setString(_deviceIdKey, newId);
    return newId;
  }

  static Future<String> getDeviceName() async {
    final prefs = await SharedPreferences.getInstance();

    // Already saved?
    String? storedName = prefs.getString(_deviceNameKey);
    if (storedName != null) return storedName;

    final deviceInfo = DeviceInfoPlugin();
    String deviceName;

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;

      // Brand + Model gives proper device name
      deviceName = "${android.brand} ${android.model}";
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;

      deviceName = ios.name;
    } else {
      deviceName = "Unknown Device";
    }

    await prefs.setString(_deviceNameKey, deviceName);
    return deviceName;
  }
}
