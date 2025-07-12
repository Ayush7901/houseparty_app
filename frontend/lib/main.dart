import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/auth/login.dart';

import 'package:frontend/auth/signup.dart';
import 'package:frontend/firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:frontend/game/game_screen.dart';
import 'package:frontend/game/points_screen.dart';
import 'package:frontend/meet/join_screen.dart';
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
          '/': (context) => StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return StartScreen();
                  }
                  return const SignUpPage();
                },
              ),
          // '/': (context) => const JoinScreen(selfCallerId: 'selfCallerId'),
          '/start-screen': (context) => StartScreen(),
          '/game-screen': (context) => GameScreen(),
          '/points-screen': (context) => PointsScreen(inputList: const {}),
          '/login-screen': (context) => const LoginPage(),
          '/signup-screen': (context) => const SignUpPage(),
          '/join-screen': (context) =>
              const JoinScreen(selfCallerId: 'selfCallerId')
        });
  }
}
