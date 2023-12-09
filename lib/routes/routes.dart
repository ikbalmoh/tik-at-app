import 'package:get/get.dart';
import 'package:tik_at_app/modules/transaction/transaction.dart';
import 'package:tik_at_app/routes/middleware.dart';
import 'package:tik_at_app/modules/auth/auth.dart';
import 'package:tik_at_app/modules/ticket/ticket.dart';

import 'package:tik_at_app/screens/splash_screen.dart';
import 'package:tik_at_app/screens/login/login.dart';
import 'package:tik_at_app/screens/home/home.dart';

class Routes {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
}

List<GetPage> routes = [
  GetPage(
    name: Routes.root,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: Routes.login,
    page: () => const Login(),
    binding: AuthBindings(),
    middlewares: [AuthenticatedMiddleware()],
  ),
  GetPage(
    name: Routes.home,
    page: () => const Home(),
    bindings: [TicketBindings(), TransactionBindings()],
    middlewares: [AuthenticatedMiddleware()],
  ),
];
