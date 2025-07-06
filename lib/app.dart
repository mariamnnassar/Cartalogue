// lib/app.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

final _appRouter = AppRouter();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cartalogue',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      routerConfig: _appRouter.config(), // 🔁 This enables auto_route
    );
  }
}
