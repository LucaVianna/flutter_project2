// Caminho lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // intl
import 'features/auth/presentation/pages/welcome_screen.dart';

// TEMA
import 'core/theme/app_theme.dart';

// NOTIFICATION SERVICE
import 'core/services/notification_service.dart';

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

  await NotificationService().initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('pt-BR', null); // inicializando intl

  runApp(
    MultiProvider(
      providers: [
        // Provider para o estado de autenticação
        ChangeNotifierProvider(create: (context) => AuthProvider()),

        // Provider para o estado do carrinho de compras
        ChangeNotifierProvider(create: (context) => CartProvider()),

        // Provider para os produtos adicionados pelos admins, agora depende de AuthProvider
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (context) => ProductProvider(context.read<AuthProvider>()), 
          update: (context, auth, previousProductProvider) {
            previousProductProvider!.updateDependencies(auth);
            return previousProductProvider;
          }
        ),

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
      theme: AppTheme.lightTheme,

      // 2. Removemos o AuthWrapper. A tela inicial será sempre a WelcomeScreen
      // A lógica de navegação será feita pelo AuthProvider agora
      home: const WelcomeScreen(),
    );
  }
}