import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Perkenalan',
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text(
          'Kartu Perkenalan',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 100,
              color: Colors.black45,
            ),

            const SizedBox(height: 20),

            const Text(
              'Mery Ismalia',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'NIM: 20240801058',
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            const Text(
              'Teknik Informatika',
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            const Text(
              'Hobi: Menari',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}