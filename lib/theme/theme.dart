import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  fontFamily: 'PlusJakartaSans',

  colorScheme: ColorScheme.light(
    surface: Color(0xFFF8F7F5),
    primary: Color(0xFF1C140D),
    onPrimary: Color(0xFF9C7349),
    secondary: Color(0xFFF48C25),
    tertiary: Color(0xFFE8DBCE),
    onSurface: Color(0xFF9C7349),
    onSurfaceVariant: Color(0xFFF4EDE7),
    surfaceTint: Colors.transparent,
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  fontFamily: 'PlusJakartaSans',

  colorScheme: ColorScheme.dark(
    // surface: Colors.brown.shade800,
    surface: Color(0xFF221910),
    primary: Color(0xFFF8F7F5),
    onPrimary: Color(0xFFD4BCA5),
    secondary: Color(0xFFF48C25),
    tertiary: Color(0xFF2C241B),
    onSurface: Color(0xFF7A6558),
    onSurfaceVariant: Color(0xFF322820),
    surfaceTint: Colors.transparent,
  ),
);

// ThemeData darkMode = ThemeData(
//   useMaterial3: false,
//   brightness: Brightness.dark,
//   fontFamily: 'PlusJakartaSans',

//   colorScheme: const ColorScheme.dark(
//     // === Main brand colors ===
//     primary: Color(0xFFF8F7F5), // ข้อความหลัก / icon
//     onPrimary: Color(0xFF221910),

//     secondary: Color(0xFFF48C25), // accent
//     onSecondary: Color(0xFF221910),

//     tertiary: Color(0xFFD97706), // accent รอง
//     onTertiary: Color(0xFF221910),

//     // === Surfaces ===
//     surface: Color(0xFF221910),
//     onSurface: Color(0xFFF8F7F5),
//     onSurfaceVariant: Color(0xFF7A6558),

//     // === Utility ===
//     outline: Color(0xFF4A3A2F),
//     outlineVariant: Color(0xFF3A2E26),

//     error: Color(0xFFEF4444),
//     onError: Color(0xFF221910),

//     shadow: Colors.black,
//     scrim: Colors.black,

//     // === สำคัญมาก ===
//     surfaceTint: Colors.transparent,
//   ),
// );
