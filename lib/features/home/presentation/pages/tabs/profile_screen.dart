// Caminho lib/features/home/presentation/pages/tabs/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:nectar_online_groceries/features/admin/presentation/pages/manage_products_screen.dart';
import 'package:nectar_online_groceries/features/admin/presentation/pages/manage_orders_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para que, se um dia o perfil mudar, a tela se atualize
    final authController = context.watch<AuthProvider>();
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
        // Fallback: caso não haja usuário, mostra loader ou mensagem
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
              leading: const Icon(Icons.settings_outlined),
              title: const Text(
                'Configurações',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navega para a tela de configurações
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const SettingsScreen())
                );
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

            // --- BLOCO DE CÓDIGO PARA ADMIN ---
            if (currentUser.isAdmin)
              Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.shield_outlined),
                    title: Text(
                      'Área do Administrador',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: const Text(
                      'Gerenciar Produtos',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Adicionar a importação para a nova tela no topo do arquivo
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ManageProductsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: const Text(
                      'Gerenciar Pedidos',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ManageOrdersScreen())
                      );
                    },
                  ),
                ],
              ),

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
                context.read<AuthProvider>().signOut();
              },
            ),
          ],
        ),
    );
  }
}