// Caminho lib/features/home/presentation/pages/tabs/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/controller/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para que, se um dia o perfil mudar, a tela se atualize
    final authController = context.watch<AuthController>();
    final currentUser = authController.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Perfil',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: currentUser == null
        //Fallback: caso não haja usuário, mostra loader ou mensagem
        // Com o nosso AuthWrapper, este caso é raro, mas é bom ter
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : ListView(
          children: [
            const SizedBox(height: 20),
            // --- INFORMAÇÕES DO USUÁRIO ---
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                currentUser.name.isNotEmpty ? currentUser.name[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                currentUser.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                currentUser.email,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),

            // --- OPÇÕES DO MENU ---
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text(
                'Meus pedidos',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Futuramente, navegar para a tela de pedidos
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text(
                'Configurações',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Futuramente, navegar para a tela de configurações
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text(
                'Ajuda',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Futuramente, navegar para a tela de ajuda
              },
            ),
            const Divider(),

            // --- BOTÃO DE LOGOUT ---
            ListTile(
              leading: const Icon(
                Icons.logout, 
                color: Colors.red,
              ),
              title: const Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // Chama o método signOut do AuthController
                // O AuthWrapper no main.dart vai detectar a mudança de estado e automaticamente redirecionar para a WelcomeScreen
                context.read<AuthController>().signOut();
              },
            ),
          ],
        ),
    );
  }
}