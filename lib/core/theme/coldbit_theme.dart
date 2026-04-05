import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColdBitTheme {
  static const Color obsidianBlack = Color(0xFF070709);
  static const Color darkGraphite = Color(0xFF121418);
  static const Color brushedMetal = Color(0xFF26282E);
  static const Color frostedGlass = Color(0xAA121418);

  static const Color pureWhiteText = Color(0xFFFAFAFA);
  static const Color platinumText = Color(0xFFA0A5AE);

  static const Color goldBitcoin = Color(0xFFD69415);
  static const Color goldBright = Color(0xFFFAC044);
  static const Color errorCrimson = Color(0xFFE53E3E);
  static const Color successGreen = Color(0xFF48BB78);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldBright, goldBitcoin],
  );

  static const LinearGradient glassBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x44FAFAFA), Color(0x00FAFAFA)],
  );

  // Shadows
  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: goldBitcoin.withValues(alpha: 0.3),
      blurRadius: 20,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> ambientShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 15,
      spreadRadius: 0,
      offset: const Offset(0, 8),
    ),
  ];

  // Theme
  static ThemeData get luxuryTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidianBlack,
      primaryColor: goldBitcoin,
      fontFamily: GoogleFonts.outfit().fontFamily,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: pureWhiteText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),

      colorScheme: const ColorScheme.dark(
        primary: goldBitcoin,
        surface: darkGraphite,
        error: errorCrimson,
        onSurface: pureWhiteText,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldBitcoin,
          foregroundColor: obsidianBlack,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            fontSize: 16,
          ),
          padding: const EdgeInsets.symmetric(vertical: 18.0),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGraphite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: brushedMetal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: brushedMetal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: goldBitcoin),
        ),
        hintStyle: GoogleFonts.outfit(color: platinumText),
      ),
    );
  }
}
