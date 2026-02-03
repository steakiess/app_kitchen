import 'package:flutter/material.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const AiroRecipeApp());
}

class AiroRecipeApp extends StatelessWidget {
  const AiroRecipeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airo Kitchen',
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