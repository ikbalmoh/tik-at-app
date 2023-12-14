import 'package:get/get.dart';
import 'setting.dart';

class SettingBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController(SettingService()));
  }
}
