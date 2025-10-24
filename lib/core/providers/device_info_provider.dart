import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/device_info_module/device_info_app.dart';

// Provides a singleton instance of DeviceInfoService
final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return DeviceInfoService();
});

// AsyncProvider to get the device ID
final deviceIdProvider = FutureProvider<String>((ref) async {
  final deviceInfoService = ref.watch(deviceInfoServiceProvider);
  return await deviceInfoService.getDeviceId();
});