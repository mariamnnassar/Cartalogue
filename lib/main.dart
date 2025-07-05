// lib/main.dart

// Importing the Flutter material package for UI widgets.
import 'package:flutter/material.dart';

// Importing Riverpod's ProviderScope to enable state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importing our main app widget from app.dart
import 'app.dart';

void main() {
  // runApp() is the first function called when the app starts.
  // ProviderScope is the root widget for Riverpod state management.
  runApp(const ProviderScope(child: MyApp()));
}
