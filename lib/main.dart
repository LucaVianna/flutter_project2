// Caminho lib/main.dart

import 'package:intl/date_symbol_data_local.dart'; // intl

import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/welcome_screen.dart';

// GLOBAL KEY PARA NAVEGAÇÃO
import 'core/services/navigation_service.dart';

// IMPORTAÇÕES DO FIREBASE
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// IMPORTAÇÕES DO PROVIDER
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/home/presentation/providers/cart_provider.dart';
import 'features/home/presentation/providers/order_provider.dart';
import 'features/home/presentation/providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('pt-br', null); // inicializando intl

  runApp(
    MultiProvider(
      providers: [
        // Provider para o estado de autenticação
        ChangeNotifierProvider(create: (context) => AuthProvider()),

        // Provider para o estado do carrinho de compras
        ChangeNotifierProvider(create: (context) => CartProvider()),

        // Provider dependente: OrderProvider depende de AuthProvider
        ChangeNotifierProxyProvider2<AuthProvider, CartProvider, OrderProvider>(
          // Instância inicial
          create: (context) => OrderProvider(
            context.read<AuthProvider>(),
            context.read<CartProvider>(),
          ),
          // Sempre que o AuthProvider/CartProvider chama o notifyListeners() 
          update: (context, auth, cart, previousOrderProvider) {
            // Se a instância anterior não existir (o que não deve acontecer após 'create'), cria uma nova por segurança
            if (previousOrderProvider == null) {
              return OrderProvider(auth, cart);
            }
            // Se já existe, apenas atualiza suas dependências e retorna a mesma instância
            previousOrderProvider.updateDependencies(auth, cart);
            return previousOrderProvider;
          },
        ),

        // Provider para os produtos adicionados pelos admins, agora depende de AuthProvider
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (context) => ProductProvider(context.read<AuthProvider>()), 
          update: (context, auth, previousProductProvider) {
            previousProductProvider!.updateDependencies(auth);
            return previousProductProvider;
          }
        )
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
      navigatorKey: NavigationService.navigatorKey,
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
          primarySwatch: const MaterialColor(
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
      // 2. Removemos o AuthWrapper. A tela inicial será sempre a WelcomeScreen
      // A lógica de navegação será feita pelo AuthController agora
      home: const WelcomeScreen(),
    );
  }
}