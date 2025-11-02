import 'package:flutter/material.dart';

class AppTheme {
  static CardThemeData cardThemeData = CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    cardTheme: cardThemeData,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Roboto', letterSpacing: 0.5),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
    useMaterial3: false,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
    cardTheme: cardThemeData,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Roboto', letterSpacing: 0.5),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
    useMaterial3: false,
  );
}
