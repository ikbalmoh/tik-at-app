import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/app.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:tik_at_app/modules/auth/auth.dart';
import 'package:get/get.dart';

Future initServices() async {
  if (kDebugMode) {
    print('INITIALIZING APP ...');
  }

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

  Get.put(AuthController(AuthService()));

  if (kDebugMode) {
    print('APP INITIALIZED');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();
  GetStorage box = GetStorage();

  runApp(App(
    hasToken: box.hasData('token'),
  ));
}
