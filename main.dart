
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {

  runApp(const TwentyFourApp());
}

class TwentyFourApp extends StatelessWidget {
  const TwentyFourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '24 Game',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
