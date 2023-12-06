import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
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
  );
}
