import 'package:avrod/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

const mycolor = MaterialColor(
  0xFF1F172E,
  <int, Color>{
    50: Color(0xFFE3E1E9),
    100: Color(0xFFB7B4C8),
    200: Color(0xFF8681A8),
    300: Color(0xFF565187),
    400: Color(0xFF2E2B67),
    500: Color(0xFF1F172E),
    600: Color(0xFF1B132A),
    700: Color(0xFF160F24),
    800: Color(0xFF110A1F),
    900: Color(0xFF0A0513),
  },
);

final appTheme = ThemeData(
  iconTheme: IconThemeData(color: textColor),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: mycolor,
  dividerColor: Colors.grey,
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(color: Colors.white),
    elevation: 0,
    backgroundColor: const Color(0xffF6DEC4),
    titleTextStyle: GoogleFonts.ptSerif(
      fontSize: 14.sp,
      color: textColor,
      fontWeight: FontWeight.bold,
    ),
  ),
  listTileTheme: const ListTileThemeData(iconColor: Colors.white),
  textTheme: TextTheme(
    bodyMedium: GoogleFonts.ptSerif(),
    titleMedium: GoogleFonts.ptSerif(
        color: textColor, fontSize: 20, fontWeight: FontWeight.w600),
    titleLarge: const TextStyle(
      color: Color(0xff201F3D),
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
    ),
    bodyLarge: const TextStyle(
        fontWeight: FontWeight.bold, fontSize: 24.0, color: Color(0xff201F3D)),
    labelMedium: const TextStyle(
      color: Color(0xff000000),
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    ),
    labelLarge: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 10.0,
    ),
    labelSmall: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontWeight: FontWeight.w700,
        fontSize: 14,
        height: 1.5),
    headlineMedium: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 24,
    ),
  ),
);
