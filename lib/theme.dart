import 'package:flutter/material.dart';
import 'package:recipe_box/common/constants/colors.dart';
// import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  // textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: ThemeColors.primaryDark,
  primaryColorLight: ThemeColors.primaryLight,
  // primaryColor: const Color(0xFF00BCD4),
  // colorScheme: const ColorScheme.light(secondary: Color(0xFF009688)),
  scaffoldBackgroundColor: ThemeColors.white,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
