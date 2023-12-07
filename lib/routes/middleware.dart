import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/modules/auth/auth.dart';
import 'package:tik_at_app/routes/routes.dart';

class AuthenticatedMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    AuthController authController = Get.find();
    GetStorage box = GetStorage();
    final String? token = box.read('token');
    if (kDebugMode) {
      print(
          'AUTHENTICATED MIDDLEWARE\n => USER TOKEN: $token\n => STATE: ${authController.state}');
    }
    if (token != null) {
      return [Routes.root, Routes.login].contains(route)
          ? const RouteSettings(name: Routes.home)
          : null;
    }

    return const RouteSettings(name: Routes.login);
  }
}
