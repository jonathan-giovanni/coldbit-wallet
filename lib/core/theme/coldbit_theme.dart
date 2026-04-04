import 'package:flutter/material.dart';

/// Diseño "High Luxury Premium"
/// Basado en el uso de negros absolutos, acentos metálicos y el "Naranja Oro Bitcoin".
class ColdBitTheme {
  // Paleta High-Luxury
  static const Color obsidianBlack = Color(0xFF070709); // Fondo extremo
  static const Color darkGraphite = Color(0xFF121418); // Superficies elevadas
  static const Color brushedMetal = Color(0xFF26282E); // Bordes e inputs
  static const Color frostedGlass = Color(0xAA121418); // Efecto blur modal
  
  static const Color pureWhiteText = Color(0xFFFAFAFA);
  static const Color platinumText = Color(0xFFA0A5AE);

  // Acentos
  static const Color goldBitcoin = Color(0xFFD69415); // Naranja ocre elegante
  static const Color errorCrimson = Color(0xFFE53E3E); // Rojo mate

  static ThemeData get luxuryTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidianBlack,
      primaryColor: goldBitcoin,
      fontFamily: '.SF Pro Display', // Default a Inter/SF
      
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
        background: obsidianBlack,
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
