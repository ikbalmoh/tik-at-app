import 'package:get/get.dart';
import 'middleware.dart';
import 'package:tik_at_app/modules/auth/auth.dart';

import 'package:tik_at_app/screens/splash_screen.dart';
import 'package:tik_at_app/screens/login/login.dart';
import 'package:tik_at_app/screens/home/home.dart';

class Routes {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
}

final List<GetPage> routes = [
  GetPage(
    name: Routes.root,
    page: () => const SplashScreen(),
    // binding: AuthBindings(),
  ),
  GetPage(
    name: Routes.login,
    page: () => const Login(),
    middlewares: [AuthenticatedMiddleware()],
  ),
  GetPage(
    name: Routes.home,
    page: () => const Home(),
    middlewares: [AuthenticatedMiddleware()],
  ),
];
