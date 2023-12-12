import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    primarySwatch: Colors.blue,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.blueGrey.shade700,
        fontWeight: FontWeight.w600,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.blueGrey.shade400,
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(fontWeight: FontWeight.bold),
      labelLarge: TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}
