import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_box/common/constants/colors.dart';
// import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
    brightness: Brightness.light,
    // textTheme: GoogleFonts.openSansTextTheme(),
    primaryColorDark: ThemeColors.primaryDark,
    primaryColorLight: ThemeColors.primaryLight,
    // primaryColor: ThemeColors.primaryLight,
    // colorScheme: const ColorScheme.light(secondary: Color(0xFF009688)),
    scaffoldBackgroundColor: ThemeColors.white,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
            // statusBarBrightness: Brightness.light,
            // statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            // systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarDividerColor: Colors.transparent,
            statusBarColor: Colors.transparent)));
