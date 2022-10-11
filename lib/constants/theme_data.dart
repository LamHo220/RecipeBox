import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final appBar = AppBar(
  title: Center(
    child: Text('Recipe Sum', style: TextStyle(color: Colors.black)),
  ),
  leading: Icon(Icons.menu),
  actions: [
    IconButton(onPressed: () => {}, icon: Icon(Icons.account_circle_rounded))
  ],
  elevation: 0,
);

final drawer = Drawer();
const white = Colors.white;
const black = Colors.black;

final whiteBorder = OutlineInputBorder(
    borderSide: BorderSide(color: white),
    borderRadius: BorderRadius.circular(24));

final themeData = ThemeData(
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.green.shade700,
        onPrimary: black,
        secondary: Colors.green.shade700,
        onSecondary: white,
        error: Colors.grey.shade600,
        onError: black,
        background: Colors.white10,
        onBackground: black,
        surface: Colors.white,
        onSurface: black));
