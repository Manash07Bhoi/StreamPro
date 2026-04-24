import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFC026D3);
  static const Color secondaryColor = Color(0xFFDB2777);
  static const Color backgroundColor = Color(0xFF0A0A0A);
  static const Color surfaceColor = Color(0xFF121212);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.poppins(
            textStyle: ThemeData.dark().textTheme.displayLarge),
        displayMedium: GoogleFonts.poppins(
            textStyle: ThemeData.dark().textTheme.displayMedium),
        displaySmall: GoogleFonts.poppins(
            textStyle: ThemeData.dark().textTheme.displaySmall),
        headlineLarge: GoogleFonts.poppins(
            textStyle: ThemeData.dark().textTheme.headlineLarge),
        headlineMedium: GoogleFonts.poppins(
            textStyle: ThemeData.dark().textTheme.headlineMedium),
        headlineSmall: GoogleFonts.poppins(
            textStyle: ThemeData.dark().textTheme.headlineSmall),
        titleLarge: GoogleFonts.poppins(
            textStyle: ThemeData.dark().textTheme.titleLarge),
        titleMedium: GoogleFonts.poppins(
            textStyle: ThemeData.dark().textTheme.titleMedium),
        titleSmall: GoogleFonts.poppins(
            textStyle: ThemeData.dark().textTheme.titleSmall),
      ),
    );
  }
}
