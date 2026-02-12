import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<Map<String, dynamic>> getDeviceInfo() async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

    return {
      "device_type": "android",
      "device_name": "${androidInfo.brand} ${androidInfo.model}",
      "model": androidInfo.model,
      "brand": androidInfo.brand,
      "android_version": androidInfo.version.release,
      "sdk_int": androidInfo.version.sdkInt,
      "device_id": androidInfo.id,
    };
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;

    return {
      "device_type": "ios",
      "model": iosInfo.utsname.machine,
      "system_version": iosInfo.systemVersion,
      "device_name": iosInfo.name,
      "identifier": iosInfo.identifierForVendor,
    };
  } else {
    return {
      "device_type": "unknown"
    };
  }
}
