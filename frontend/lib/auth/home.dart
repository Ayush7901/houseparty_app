import 'package:flutter/material.dart';
import 'package:frontend/state/playerProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Star decorations
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/stars.png', // Add your star pattern image in assets folder
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game title
                Text(
                  'Word Blitz',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black54,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Username input
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Make an Username',
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 20),
                // Enter button
                ElevatedButton(
                  onPressed: () {
                    print("Username: $_usernameController");
                    String username = _usernameController.text;
                    if (username.length > 0) {
                      Provider.of<PlayerProvider>(context, listen: false)
                          .setUserName(username);
                      Navigator.pushReplacementNamed(context, "/create-meet");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Go to Game',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
