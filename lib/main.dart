import 'package:flutter/material.dart';
import 'package:tik_at_app/login/login.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tik@ Situ Bagendit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: const TextTheme(
            headlineMedium: TextStyle(fontWeight: FontWeight.w600),
            headlineSmall: TextStyle(fontWeight: FontWeight.w600)),
      ),
      home: const Login(),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
        ],
        child: child!,
      ),
    );
  }
}
