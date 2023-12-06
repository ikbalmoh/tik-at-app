import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/app.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  final deviceInfoPlugin = DeviceInfoPlugin();

  String deviceName;

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
      deviceName = deviceInfo.display;
      break;
    case TargetPlatform.iOS:
      IosDeviceInfo deviceInfo = await deviceInfoPlugin.iosInfo;
      deviceName = deviceInfo.name;
      break;
    default:
      WebBrowserInfo deviceInfo = await deviceInfoPlugin.webBrowserInfo;
      deviceName = deviceInfo.browserName.name;
      break;
  }
  if (kDebugMode) {
    print('DEVICE: $deviceName');
  }

  GetStorage box = GetStorage();
  box.write('device', deviceName);

  runApp(const App());
}
