import 'package:gartix/modules/auth/widget/login.dart';
import 'package:get/get.dart';
import 'package:gartix/modules/setting/controller/setting.dart';
import 'package:gartix/modules/transaction/controller/transaction.dart';
import 'package:gartix/core/routes/middleware.dart';
import 'package:gartix/modules/auth/controller/auth.dart';
import 'package:gartix/modules/ticket/controller/ticket.dart';

import 'package:gartix/modules/splash/widget/splash_screen.dart';
import 'package:gartix/modules/transaction/widget/home.dart';

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
