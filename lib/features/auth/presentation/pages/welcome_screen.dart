// Caminho lib/features/auth/presentation/pages/welcome_screen.dart

import 'package:flutter/material.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem no fundo
          Positioned.fill(
            child: Image.asset(
              'assets/welcome-background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Conteúdo centralizado
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                // Pequena cenoura
                SizedBox(
                  height: 65,
                  width: 65,
                  child: Image.asset(
                    'assets/carrot-branca-transparente.png',
                  ),
                ),
                const SizedBox(height: 10),

                // Título de boas-vindas
                const Text(
                  'Bem-vindo à nossa loja',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Subtítulo de boas-vindas
                const Text(
                  'Receba suas compras em casa!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Botão de ação
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegação para a próxima tela
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      'Começar',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}