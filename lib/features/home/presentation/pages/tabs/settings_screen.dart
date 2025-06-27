import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';
import 'edit_profile_screen.dart';

// Futuramente importaremos a tela de edição aqui
// import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              // Ação de Editar Perfil
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const EditProfileScreen())
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
          const Divider(
            color: Colors.red,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,              
            ),
            title: const Text(
              'Excluir Conta',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            subtitle: const Text(
              'Esta ação é permanente',
            ),
            onTap: () async {
              // Lógica de Confirmação e Exclusão

              // Usamos 'read' pois estamos dentro de um função callback
              final authProvider = context.read<AuthProvider>();
              // Capturamos o ScaffoldMessenger e o Navigator antes do 'await' por segurança
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              // 1. Mostra um diálogo de confirmação e espera a resposta do usuário
              final bool? confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    'Confirmar Exclusão',
                  ),
                  content: const Text(
                    'Você tem certeza de que deseja excluir sua conta? Todos os seus dados, incluindo seus pedidos, serão perdidos permanentemente. Esta ação não pode ser desfeita.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false), 
                      child: const Text(
                        'Não',
                      ),
                    ),
                    TextButton(
                      // O botão 'Cancelar' retorna false
                      onPressed: () => Navigator.of(ctx).pop(true), 
                      child: const Text(
                        'Sim, Excluir',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );

              // 2. Se o usuário confirmou (retornou true)
              if (confirmed == true) {
                // chama o método de exclusão no provider
                final String? error = await authProvider.deleteCurrentUserAcount();

                // A navegação para a WelcomeScreen já acontece dentro do provider
                if (navigator.mounted && error != null) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erro ao excluir conta: $error',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}