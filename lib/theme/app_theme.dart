import 'package:flutter/material.dart';

/// CatNotes Brand-Farben — zentrale Quelle für alle Widgets.
/// Direkte Verwendung nur wenn Theme.of(context) nicht ausreicht.
class CatColors {
  CatColors._();

  static const primary      = Color(0xFF7C5CBF); // Haupt-Lila
  static const primaryLight = Color(0xFFEDE8FF); // Helles Lavendel (Input-Fill)
  static const surface      = Color(0xFFF8F7FC); // Warmes Off-White (Scaffold)
  static const cardWhite    = Color(0xFFFFFFFF); // Karten-Weiß
  static const peach        = Color(0xFFFFB5A7); // Warmer Akzent
  static const textDark     = Color(0xFF2D2640); // Primärtext
  static const textMid      = Color(0xFF8B85A0); // Sekundärtext
  static const divider      = Color(0xFFE8E4F0); // Trennlinie
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _build();
  // Darkmode noch nicht umgesetzt – bleibt beim Light-Theme.
  static ThemeData get darkTheme => _build();

  static ThemeData _build() {
    final cs = ColorScheme.fromSeed(
      seedColor: CatColors.primary,
    ).copyWith(
      surface: CatColors.surface,
      onSurface: CatColors.textDark,
      primaryContainer: CatColors.primaryLight,
      onPrimaryContainer: CatColors.primary,
      surfaceContainerHighest: CatColors.primaryLight,
      error: const Color(0xFFD64A4A),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: CatColors.surface,

      // ── Karten ────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: CatColors.primary.withValues(alpha: 0.10),
        color: CatColors.cardWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: CatColors.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: CatColors.textDark,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: CatColors.primary),
        actionsIconTheme: IconThemeData(color: CatColors.primary),
      ),

      // ── Buttons – Pill-Form, senior-freundliche Mindesthöhe ───────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const StadiumBorder(),
        ),
      ),

      // ── FAB – kreisförmig (M3 default ist rounded square) ─────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
        elevation: 4,
      ),

      // ── Inputs – soft filled, kein harter Outline-Rand ────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CatColors.primaryLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: CatColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD64A4A), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: CatColors.textMid),
        labelStyle: const TextStyle(color: CatColors.textMid),
        floatingLabelStyle: const TextStyle(
          color: CatColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ── Typografie – klare Hierarchie, senior-freundlich ──────────────────
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: CatColors.textDark,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: CatColors.textDark,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CatColors.textDark,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: CatColors.textDark,
        ),
        bodyLarge: TextStyle(fontSize: 17, color: CatColors.textDark),
        bodyMedium: TextStyle(fontSize: 15, color: CatColors.textDark),
        bodySmall: TextStyle(fontSize: 13, color: CatColors.textMid),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: CatColors.textDark,
        ),
        labelMedium: TextStyle(fontSize: 13, color: CatColors.textMid),
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: CatColors.divider,
        space: 1,
        thickness: 1,
      ),

      // ── SnackBar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: CatColors.textDark,
      ),
    );
  }
}
