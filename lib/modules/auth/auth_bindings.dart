import 'package:get/get.dart';

import 'package:tik_at_app/modules/auth/auth.dart';

class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(AuthService()));
  }
}
