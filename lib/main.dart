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
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  runApp(App(authenticationRepository: authenticationRepository));
}
