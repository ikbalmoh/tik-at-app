import 'package:get/get.dart';
import 'package:gartix/modules/setting/setting.dart';
import 'package:gartix/modules/transaction/transaction.dart';
import 'package:gartix/routes/middleware.dart';
import 'package:gartix/modules/auth/auth.dart';
import 'package:gartix/modules/ticket/ticket.dart';

import 'package:gartix/screens/splash_screen.dart';
import 'package:gartix/screens/login/login.dart';
import 'package:gartix/screens/home/home.dart';

class Routes {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
}

List<GetPage> routes = [
  GetPage(
    name: Routes.root,
    bindings: [SettingBindings()],
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: Routes.login,
    page: () => const Login(),
    bindings: [SettingBindings(), AuthBindings()],
    middlewares: [AuthenticatedMiddleware()],
  ),
  GetPage(
    name: Routes.home,
    page: () => const Home(),
    bindings: [SettingBindings(), TicketBindings(), TransactionBindings()],
    middlewares: [AuthenticatedMiddleware()],
  ),
];
