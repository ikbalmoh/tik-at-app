import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gartix/app.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:gartix/modules/auth/controller/auth.dart';
import 'package:get/get.dart';
import 'package:gartix/modules/setting/controller/setting.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future initServices() async {
  if (kDebugMode) {
    print('INITIALIZING APP ...');
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print('ERROR DETAILS: $details');
    } else {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      print('ERROR OCCURED:\n error => $error\n stack => $stack');
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };

  await GetStorage.init();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appVersion = packageInfo.version;

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

  box.write('version', appVersion);
  box.write('device', deviceName);

  Get.put(SettingController(SettingService()));
  Get.put(AuthController(AuthService()));

  if (kDebugMode) {
    print('APP INITIALIZED');
  }

  final bool hasApi = box.hasData('api');
  return hasApi;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  GetStorage box = GetStorage();

  runApp(App(
    hasToken: box.hasData('token'),
  ));
}
