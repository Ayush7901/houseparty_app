import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:frontend/auth/signup.dart';
import 'package:frontend/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:frontend/game/game_screen.dart';
import 'package:frontend/game/points_screen.dart';
import 'package:frontend/theme/theme_data.dart';
import './game/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeManager.lightTheme,
        routes: {
          '/' : (context) => SignUpPage(),
          '/start-screen': (context) => StartScreen(), // Define the default route
          '/game-screen': (context) =>
              GameScreen(), // Define a named route for the game screen
          '/points-screen': (context) => PointsScreen(
              inputList: const {}), // Define a named route for the settings screen
          // Add more named routes as needed
        });
  }
}
