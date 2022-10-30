import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pad {
  const Pad();
  static const Widget h4 = SizedBox(height: 4);
  static const Widget h8 = SizedBox(height: 8);
  static const Widget h12 = SizedBox(height: 12);
  static const Widget h24 = SizedBox(height: 24);
  static const Widget w4 = SizedBox(width: 4);
  static const Widget w8 = SizedBox(width: 8);
  static const Widget w12 = SizedBox(width: 12);
  static const Widget w16 = SizedBox(width: 16);
  static const Widget w24 = SizedBox(width: 24);
  static const EdgeInsetsDirectional pa4 = EdgeInsetsDirectional.all(4);
  static const EdgeInsetsDirectional pa8 = EdgeInsetsDirectional.all(8);
  static const EdgeInsetsDirectional pa12 = EdgeInsetsDirectional.all(12);
  static const EdgeInsetsDirectional pa24 = EdgeInsetsDirectional.all(24);
  static const EdgeInsetsDirectional plr24 =
      EdgeInsetsDirectional.only(start: 24, end: 24);
  static const EdgeInsetsDirectional ptb24 =
      EdgeInsetsDirectional.only(top: 24, bottom: 24);
}
