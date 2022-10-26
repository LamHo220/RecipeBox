import 'package:flutter/material.dart';
import 'package:recipe_box/common/constants/style.dart';

Widget heading(text) {
  return Text(
    text,
    style: Style.heading,
  );
}

Widget seeAll(void Function()? f) {
  return TextButton(
      onPressed: f, child: const Text('see all', style: Style.labelButton));
}
