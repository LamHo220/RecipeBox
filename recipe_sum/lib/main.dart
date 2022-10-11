import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_sum/home.dart';

void main() async {
  await Hive.initFlutter();
  // ..registerAdapter(PersonAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetX Store',
      // initialBinding: StoreBinding(),
      // theme: Themes.lightTheme,
      // darkTheme: Themes.darkTheme,
      // themeMode: themeController.theme,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => Home(),
        ),
        // GetPage(name: '/edit_name', page: () => UpdateStoreName()),
        // GetPage(name: '/add_followers', page: () => AddFollowers()),
        // GetPage(name: '/toggle_status', page: () => StoreStatus()),
        // GetPage(name: '/edit_follower_count', page: () => AddFollowerCount()),
        // GetPage(name: '/add_reviews', page: () => AddReviews()),
        // GetPage(name: '/update_menu', page: () => const UpdateMenu()),
      ],
      home: Home(),
    );
  }
}
