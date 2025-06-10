import 'package:flutter/material.dart';
import './pages/welcome_screen.dart';

// IMPORTAÇÕES DO FIREBASE
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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