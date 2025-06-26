import 'package:flutter/material.dart';

// Futuramente importaremos a tela de edição aqui
// import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text(
              'Editar Perfil',
            ),
            subtitle: const Text(
              'Mude seu nome e outras informações',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Ação de Editar Perfil (A ser implementado)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(
                  'Tela de Editar Perfil a ser implementada'
                )),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Alterar Senha'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Futura tela de alterar senha
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text(
              'Notificações',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Futura tela de configuração de notificação
            },
          ),
        ],
      ),
    );
  }
}