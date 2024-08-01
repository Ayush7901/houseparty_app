import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/auth/home.dart';
import 'package:frontend/auth/login.dart';

import 'package:frontend/auth/signup.dart';
import 'package:frontend/firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:frontend/game/game_screen.dart';
import 'package:frontend/game/points_screen.dart';
import 'package:frontend/state/playerProvider.dart';
import 'package:frontend/state/pointsProvider.dart';
import 'package:frontend/state/videoCallProvider.dart';
import 'package:frontend/theme/theme_data.dart';
import 'package:frontend/video_call/create_meet.dart';
import 'package:frontend/video_call/signalling_server.dart';
import 'package:provider/provider.dart';
import './game/start_screen.dart';
import './constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => VideoCallProvider()),
    ChangeNotifierProvider(create: (context) => PlayerProvider()),
    ChangeNotifierProvider(create: (context) => PointsProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // signalling server url
  final String websocketUrl = "http://$ipAddress:35272";
  // generate callerID of local user
  final String selfCallerID =
      Random().nextInt(999999).toString().padLeft(6, '0');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SignallingService.instance.init(
      websocketUrl: websocketUrl,
      selfCallerID: selfCallerID,
    );
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeManager.lightTheme,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return HomePage();
                  }
                  return const HomePage();
                },
              ),
          '/game-screen': (context) => GameScreen(),
          '/points-screen': (context) => PointsScreen(inputList: const {}),
          '/login-screen': (context) => const LoginPage(),
          '/signup-screen': (context) => const SignUpPage(),
          '/create-meet': (context) => CreateMeet()
        });
  }
}
