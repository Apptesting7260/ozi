import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  // static const _storage = FlutterSecureStorage();
  // static const _key = 'permanent_device_id';

  // static Future<String> getPersistentID() async {
  //   String? savedId = await _storage.read(key: _key);

  //   if (savedId != null) {
  //     print("Ios ID: ${savedId.toString()}");
  //     return savedId;
  //   } else {
  //     var uuid = const Uuid().v4();
  //     await _storage.write(
  //       key: _key,
  //       value: uuid,
  //       iOptions: const IOSOptions(
  //         accessibility: KeychainAccessibility.first_unlock,
  //       ),
  //     );

  //     return uuid;
  //   }
  // }
  static const _storage = FlutterSecureStorage();
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<String> getFinalUniqueId() async {
    String? deviceId;
    try {
      if (Platform.isAndroid) {
        // Android ID: No storage needed, always persistent unless factory reset
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        // iOS Keychain: Persistent even after uninstall
        deviceId = await _storage.read(key: 'my_unique_device_id');
        if (deviceId == null) {
          IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor ?? const Uuid().v4();
          await _storage.write(
            key: 'my_unique_device_id',
            value: deviceId,
            iOptions: const IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );
        }
      }
    } catch (e) {
      deviceId = "unknown_id";
    }
    return deviceId ?? "unknown_id";
  }
  // static const _storagee = FlutterSecureStorage();
  // static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // static Future<String?> getUniqueId() async {
  //   String? deviceId;

  //   try {
  //     if (Platform.isAndroid) {
  //       // 1. Android ID fetch karein
  //       AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
  //       deviceId = androidInfo.id; // Yeh uninstall ke baad same rehti hai
  //     }
  //     else if (Platform.isIOS) {
  //       // 2. iOS ke liye pehle Keychain check karein
  //       deviceId = await _storage.read(key: 'my_unique_device_id');

  //       if (deviceId == null) {
  //         // Agar pehli baar app install hui hai, toh naya UUID generate karein
  //         deviceId = const Uuid().v4();
  //         // Ise Keychain mein save kar dein (Uninstall par delete nahi hoga)
  //         await _storage.write(key: 'my_unique_device_id', value: deviceId);
  //       }
  //     }
  //   } catch (e) {
  //     print("Error fetching device ID: $e");
  //   }

  //   return deviceId;
  // }
}
