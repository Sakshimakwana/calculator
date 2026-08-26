import 'package:app_matic_tech_flutter_app/text_widgets/motivational_quotes.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motivational Quotes',
      home: const SplashScreen(),
    );
  }
}