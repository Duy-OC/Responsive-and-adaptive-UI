import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const AdaptiveNotesApp());

class AdaptiveNotesApp extends StatelessWidget {
  const AdaptiveNotesApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Adaptive Notes',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF386A5B)),
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF386A5B),
        brightness: Brightness.dark,
      ),
    ),
    home: const HomeScreen(),
  );
}
