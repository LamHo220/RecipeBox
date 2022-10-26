import 'package:flutter/widgets.dart';
import 'package:recipe_box/app/app.dart';
import 'package:recipe_box/home/home.dart';
import 'package:recipe_box/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  // switch (state) {
  // case AppStatus.authenticated:
  // return [HomePage.page()];
  // case AppStatus.unauthenticated:
  //   return [LoginPage.page()];
  return [HomePage.page()];
  // }
}
