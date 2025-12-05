// lib/app/theme.dart ← VERSION QUI MARCHE À 1000% (Flutter 3.24+)
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,

  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1E88E5),
    primary: const Color(0xFF1E88E5),
    secondary: const Color(0xFF00C853),     // Vert sécurité
    error: const Color(0xFFE53935),
    surface: Colors.white,
    background: Colors.white,
  ),

  // BOUTONS TRÈS DOUX
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    ),
  ),

  // CARDTHÈME CORRIGÉ UNE BONNE FOIS POUR TOUTES
  cardTheme: const CardThemeData(          // ← CardThemeData, pas CardTheme !
    elevation: 0,
    color: Color(0xFFF8FAFF),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    clipBehavior: Clip.hardEdge,
    margin: EdgeInsets.all(12),
  ),

  // TEXTES PROPRES
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 15, color: Colors.black54),
  ),
);