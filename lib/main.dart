import 'package:flutter/material.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const CozyRecipeApp());
}

class CozyRecipeApp extends StatelessWidget {
  const CozyRecipeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cozy GOGO Kitchen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFFF5E6),
        fontFamily: 'Georgia',
      ),
      home: const SplashPage(), // Changed from HomePage to SplashPage
    );
  }
}