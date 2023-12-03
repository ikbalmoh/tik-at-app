import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:tik_at_app/routes/routes.dart';
import 'package:tik_at_app/screens/login/login.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
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
      title: 'Tik@ Situ Bagendit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryTextTheme:
            GoogleFonts.varelaRoundTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.varelaRound(
            color: Colors.blueGrey.shade700,
            fontWeight: FontWeight.w600,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.blueGrey.shade400,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.varelaRound(),
          headlineSmall: GoogleFonts.varelaRound(),
          bodyMedium: GoogleFonts.varelaRound(),
          labelLarge: GoogleFonts.varelaRound(fontWeight: FontWeight.w600),
        ),
      ),
      home: const Login(),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
        ],
        child: child!,
      ),
      initialRoute: Routes.login,
      getPages: routes,
    );
  }
}
