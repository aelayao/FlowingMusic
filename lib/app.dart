import 'package:flutter/material.dart';
import 'home.dart';

class FlowingMusicApp extends StatelessWidget {
  const FlowingMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flowing Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1335),
        primaryColor: const Color(0xFF533285),
      ),
      home: const HomeScreen(),
    );
  }
}