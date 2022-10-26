import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_box/pages/home.dart';

void main() async {
  // await Hive.initFlutter();
  // ..registerAdapter(PersonAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Sum',
      // initialBinding: StoreBinding(),
      // darkTheme: Themes.darkTheme,
      // themeMode: themeController.theme,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => Home(),
        ),
        GetPage(name: '/favorite', page: () => Scaffold()),
        GetPage(name: '/explore', page: () => Scaffold()),
        GetPage(name: '/profile', page: () => Scaffold()),
        // GetPage(name: '/edit_follower_count', page: () => AddFollowerCount()),
        // GetPage(name: '/add_reviews', page: () => AddReviews()),
        // GetPage(name: '/update_menu', page: () => const UpdateMenu()),
      ],
      home: Home(),
    );
  }
}
