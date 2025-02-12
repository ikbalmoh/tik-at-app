import 'package:get/get.dart';

import 'package:gartix/modules/auth/auth.dart';

class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(AuthService()));
  }
}
