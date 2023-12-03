import 'package:get/get.dart';

import 'package:tik_at_app/screens/login/login.dart';
import 'package:tik_at_app/screens/home/home.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
}

final List<GetPage> routes = [
  GetPage(name: Routes.login, page: () => const Login()),
  GetPage(name: Routes.home, page: () => const Home()),
];
