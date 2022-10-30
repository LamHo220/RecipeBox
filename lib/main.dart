import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_box/app/app.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // await Hive.initFlutter();
  // ..registerAdapter(PersonAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.);
  runApp(App(authenticationRepository: authenticationRepository));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   // final themeController = Get.put(ThemeController());

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Recipe Sum',
//       // initialBinding: StoreBinding(),
//       // darkTheme: Themes.darkTheme,
//       // themeMode: themeController.theme,
//       initialRoute: '/',
//       routes: {
//         '/': (context) => Home(),
//         '/favorite': (context) => Scaffold(),
//         '/explore': (context) => Scaffold(),
//         '/profile': (context) => Scaffold(),
//       },
//     );
//   }
// }
