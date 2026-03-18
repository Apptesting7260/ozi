// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';

// Future<Map<String, dynamic>> getDeviceInfo() async {
//   final deviceInfoPlugin = DeviceInfoPlugin();

//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

//     return {
//       "device_type": "android",
//       "device_name": "${androidInfo.brand} ${androidInfo.model}",
//       "model": androidInfo.model,
//       "brand": androidInfo.brand,
//       "android_version": androidInfo.version.release,
//       "sdk_int": androidInfo.version.sdkInt,
//       "device_id": androidInfo.id,
//     };
//   } else if (Platform.isIOS) {
//     IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;

//     return {
//       "device_type": "ios",
//       "model": iosInfo.utsname.machine,
//       "system_version": iosInfo.systemVersion,
//       "device_name": iosInfo.name,
//       "identifier": iosInfo.identifierForVendor,
//       "device_id":iosInfo.persistentId,
//     };
//   } else {
//     return {"device_type": "unknown"};
//   }
// }
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

Future<Map<String, dynamic>> getDeviceInfo() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  const storage = FlutterSecureStorage();
  const uuidGenerator = Uuid();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

    return {
      "device_type": "android",
      "device_name": "${androidInfo.brand} ${androidInfo.model}",
      "model": androidInfo.model,
      "brand": androidInfo.brand,
      "android_version": androidInfo.version.release,
      "sdk_int": androidInfo.version.sdkInt,
      "device_id":
          androidInfo.id, // Android ID uninstall ke baad bhi same rehti hai
    };
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;

    String? deviceId = await storage.read(key: 'permanent_device_id');

    if (deviceId == null) {
      deviceId = iosInfo.identifierForVendor ?? uuidGenerator.v4();

      await storage.write(
        key: 'permanent_device_id',
        value: deviceId,
        iOptions: const IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      );
    }

    return {
      "device_type": "ios",
      "model": iosInfo.utsname.machine,
      "system_version": iosInfo.systemVersion,
      "device_name": iosInfo.name,
      "identifier": iosInfo.identifierForVendor,
      "device_id": deviceId,
    };
  } else {
    return {"device_type": "unknown"};
  }
}
