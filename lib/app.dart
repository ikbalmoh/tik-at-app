import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/auth/auth.dart';

import 'package:tik_at_app/routes/routes.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:tik_at_app/utils/theme.dart';

class App extends StatelessWidget {
  final bool hasToken;

  const App({required this.hasToken, super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.shortestSide < 451) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: kDebugMode,
      title: 'eTiket Situ Bagendit',
      theme: appTheme(context),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
        ],
        child: child!,
      ),
      initialRoute: hasToken ? Routes.home : Routes.login,
      initialBinding: AuthBindings(),
      getPages: routes,
    );
  }
}
