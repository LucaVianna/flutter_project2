// Caminho lib/main.dart

import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/welcome_screen.dart';
import 'features/home/presentation/pages/home_screen.dart';

// IMPORTAÇÕES DO FIREBASE
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// IMPORTAÇÕES DO PROVIDER e CONTROLLER
import 'package:provider/provider.dart'; // PROVIDER
import 'features/auth/presentation/controller/auth_controller.dart';
import 'features/home/presentation/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        // Provider para o estado de autenticação
        ChangeNotifierProvider(create: (context) => AuthController()),

        // Provider para o estado do carrinho de compras
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nectar Online Groceries',
      theme: ThemeData(
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Color(0xFF4AA66C),
        //     foregroundColor: Colors.white,
        //   ),
        // ),

        // THEME INPUT FIELD
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4AA66C), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),

        // THEME GERAL
        primaryColor: const Color(0xFF4AA66C),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            0xFF4AA66C,
            <int, Color>{
              50: Color(0xFFE8F5E9),
              100: Color(0xFFC8E6C9),
              200: Color(0xFFA5D6A7),
              300: Color(0xFF81C784),
              400: Color(0xFF66BB6A),
              500: Color(0xFF4AA66C), // BASE
              600: Color(0xFF43A047),
              700: Color(0xFF388E3C),
              800: Color(0xFF2E7D32),
              900: Color(0xFF1B5E20),
            },
          ),
        ).copyWith(secondary: const Color(0xFFFFC107))
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Ouve mudanças no AuthController, quando _currentUser ou _isLoading mudam, este widget reconstrói
    final authController = context.watch<AuthController>();

    // Se o controller está em processo de verificação ou carregamento, mostra loader
    // isLoading do AuthController é usada para isso
    if (authController.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Se há um usuário logado -> HomeScreen
    if (authController.currentUser != null) {
      return const HomeScreen();
    } else {
    // Se não houver usuário logado -> WelcomeScreen
      return const WelcomeScreen();
    }
  }
}