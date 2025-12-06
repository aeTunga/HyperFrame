import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Light Theme Configuration
///
/// Modern Material 3 theme with Indigo as the primary color.
/// Uses Google's Inter font family for consistent typography.
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1), // Indigo color
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.interTextTheme(),
  cardTheme: const CardThemeData(elevation: 2, margin: EdgeInsets.all(8)),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black87,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);

/// Dark Theme Configuration
///
/// Modern Material 3 dark theme with Indigo as the primary color.
/// Optimized for OLED displays with true blacks.
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1), // Indigo color
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  cardTheme: const CardThemeData(elevation: 2, margin: EdgeInsets.all(8)),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);
