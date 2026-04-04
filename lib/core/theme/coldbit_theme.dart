import 'package:flutter/material.dart';

class ColdBitTheme {
  static const Color obsidianBlack = Color(0xFF070709);
  static const Color darkGraphite = Color(0xFF121418);
  static const Color brushedMetal = Color(0xFF26282E);
  static const Color frostedGlass = Color(0xAA121418);
  
  static const Color pureWhiteText = Color(0xFFFAFAFA);
  static const Color platinumText = Color(0xFFA0A5AE);

  static const Color goldBitcoin = Color(0xFFD69415);
  static const Color errorCrimson = Color(0xFFE53E3E);

  static ThemeData get luxuryTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidianBlack,
      primaryColor: goldBitcoin,
      fontFamily: '.SF Pro Display',
      
      appBarTheme: const AppBarTheme(
        backgroundColor: obsidianBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
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
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: const TextStyle(
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
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: brushedMetal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: brushedMetal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: goldBitcoin),
        ),
        hintStyle: const TextStyle(color: platinumText),
      ),
    );
  }
}
