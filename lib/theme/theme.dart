import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0x8BCEE2D7),
    secondary: Color(0xB841971C),
    tertiary: Color(0xABDF2E37),
    surface: Color(0xffE8F9FD),
    onSurface: Color(0xff000000),
  ),
  textTheme: TextTheme(
    displayMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, color: Color(0xff000000)),
    ),
    headlineLarge: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: Color(0xff000000)),
    ),
    headlineMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: Color(0xff000000)),
    ),
    headlineSmall: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: Color(0xff000000)),
    ),
    titleMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, color: Color(0xffE8F9FD)),
    ),
    bodyMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w400, color: Color(0xff000000)),
    ),
  ),
  dividerColor: const Color(0xff000000),
);

ThemeData darkMode = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xff222831),
    secondary: Color(0xff367E18),
    tertiary: Color(0xffDF2E38),
    surface: Color(0xff000000),
    onSurface: Color(0xffE8F9FD),
  ),
  textTheme: TextTheme(
    displayMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, color: Color(0xffE8F9FD)),
    ),
    headlineLarge: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: Color(0xffE8F9FD)),
    ),
    headlineMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: Color(0xffE8F9FD)),
    ),
    headlineSmall: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: Color(0xffE8F9FD)),
    ),
    titleMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, color: Color(0xff000000)),
    ),
    bodyMedium: GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          fontWeight: FontWeight.w400, color: Color(0xffE8F9FD)),
    ),
  ),
  dividerColor: const Color(0xffE8F9FD),
);
