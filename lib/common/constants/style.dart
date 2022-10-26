import 'package:flutter/material.dart';

import 'colors.dart';

class Style {
  const Style();

  static const TextStyle welcome = TextStyle(
      color: ThemeColors.primaryLight,
      fontSize: 22,
      height: 1.5,
      fontWeight: FontWeight.bold);

  static const TextStyle question =
      TextStyle(color: ThemeColors.gray, fontSize: 16, height: 1.5);

  static const TextStyle search = TextStyle(
      color: ThemeColors.inactive, fontSize: 16, fontWeight: FontWeight.w500);

  static const TextStyle heading = TextStyle(
      color: ThemeColors.text,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.5);

  static const TextStyle labelButton = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: ThemeColors.primaryLight);

  static const TextStyle cardTitle = TextStyle(
    color: ThemeColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle cardSubTitle = TextStyle(
      color: ThemeColors.white, fontSize: 14, fontWeight: FontWeight.w400);

  static final TextStyle highlightText =
      heading.copyWith(color: ThemeColors.primaryDark);

  static const TextStyle label = TextStyle(
    color: ThemeColors.text,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
