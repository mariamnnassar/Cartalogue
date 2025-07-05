// lib/app.dart

import 'package:flutter/material.dart';
import 'features/home/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Title used in Android app switcher or task manager
      title: 'Cartalogue',

      // Remove debug banner in top-right corner
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: ThemeData(
        primarySwatch: Colors.brown, // Main color of the app
      ),

      // Temporary home screen until we create HomeScreen
      home: const HomeScreen(), // We'll replace this later with HomeScreen()
    );
  }
}
