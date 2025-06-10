import 'package:flutter/material.dart';
import './pages/welcome_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4AA66C),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}