import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Brand Colors ──────────────────────────────────────────────
  static const Color _oxfordBlue = Color(0xFF050A30);

  // ── Material 3 Color Scheme (from Stitch design system) ──────
  static final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary
    primary: const Color(0xFF904D00),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFFF8C00),
    onPrimaryContainer: const Color(0xFF623200),
    primaryFixed: const Color(0xFFFFDCC3),
    primaryFixedDim: const Color(0xFFFFB77D),
    onPrimaryFixed: const Color(0xFF2F1500),
    onPrimaryFixedVariant: const Color(0xFF6E3900),
    inversePrimary: const Color(0xFFFFB77D),
    // Secondary
    secondary: const Color(0xFF565C84),
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFCACFFE),
    onSecondaryContainer: const Color(0xFF52577F),
    secondaryFixed: const Color(0xFFDFE0FF),
    secondaryFixedDim: const Color(0xFFBFC3F2),
    onSecondaryFixed: const Color(0xFF13183D),
    onSecondaryFixedVariant: const Color(0xFF3F446B),
    // Tertiary
    tertiary: const Color(0xFF00658F),
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFF00B5FC),
    onTertiaryContainer: const Color(0xFF004360),
    tertiaryFixed: const Color(0xFFC7E7FF),
    tertiaryFixedDim: const Color(0xFF85CFFF),
    onTertiaryFixed: const Color(0xFF001E2E),
    onTertiaryFixedVariant: const Color(0xFF004C6C),
    // Error
    error: const Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: const Color(0xFF93000A),
    // Surface
    surface: const Color(0xFFFBF9F9),
    onSurface: const Color(0xFF1B1C1C),
    surfaceDim: const Color(0xFFDBDAD9),
    surfaceBright: const Color(0xFFFBF9F9),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: const Color(0xFFF5F3F3),
    surfaceContainer: const Color(0xFFEFEDED),
    surfaceContainerHigh: const Color(0xFFE9E8E7),
    surfaceContainerHighest: const Color(0xFFE3E2E2),
    surfaceTint: const Color(0xFF904D00),
    onSurfaceVariant: const Color(0xFF564334),
    inverseSurface: const Color(0xFF303031),
    onInverseSurface: const Color(0xFFF2F0F0),
    // Outline
    outline: const Color(0xFF897362),
    outlineVariant: const Color(0xFFDDC1AE),
    // Misc
    shadow: Colors.black,
    scrim: Colors.black,
  );

  // ── Text Theme ────────────────────────────────────────────────
  static TextTheme _buildTextTheme() {
    return GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          height: 56 / 48,
          letterSpacing: -0.02 * 48,
          color: _oxfordBlue,
        ),
        headlineLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 40 / 32,
          letterSpacing: -0.01 * 32,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 34 / 28,
          letterSpacing: -0.01 * 28,
        ),
        titleMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 28 / 20,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
        ),
        labelMedium: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          letterSpacing: 0.05 * 12,
        ),
      ),
    );
  }

  // ── Full ThemeData ────────────────────────────────────────────
  static ThemeData get themeData {
    final textTheme = _buildTextTheme().apply(
      bodyColor: _oxfordBlue,
      displayColor: _oxfordBlue,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        surface: Colors.white,
        onSurface: _oxfordBlue,
        onSurfaceVariant: _oxfordBlue.withValues(alpha: 0.8),
        primaryContainer: const Color(0xFFFF8C00), // Dark Orange
        onPrimaryContainer: Colors.white,
      ),
      textTheme: textTheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: _oxfordBlue,
        ),
        iconTheme: const IconThemeData(color: _oxfordBlue),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF8C00), // Dark Orange
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFF8C00),
          side: const BorderSide(color: Color(0xFFFF8C00)),
          minimumSize: const Size(0, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
