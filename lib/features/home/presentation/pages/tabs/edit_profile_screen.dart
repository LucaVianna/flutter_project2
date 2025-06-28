import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  // Será iniciado uma vez e nunca mais mudará
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final initialName = context.read<AuthProvider>().currentUser?.name ?? '';
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() { _isLoading = true; });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.updateUserProfile(
      newName: _nameController.text.trim(),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
            'Perfil atualizado com sucesso',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Erro ao atualizar o perfil',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo',
                    icon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'O nome não pode ficar em branco' : null,
                ),
                // No futuro, outros campos como email, telefone, etc
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ), 
                  child: _isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                    )
                    : const Text(
                      'Salvar alterações'
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}