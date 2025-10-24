import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    if (kIsWeb) return "Web browser - no device ID";

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? "";
      }
    } catch (e) {
      debugPrint("Error getting device ID: $e");
    }

    return "Unknown device ID";
  }
}
