import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../home/presentation/providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Chave para identificar e validar nosso formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores para pegar os valores dos campos de texto
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nutritionController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _imagePathController = TextEditingController();

  // Estado para controlar o loading do botão de salvar
  bool _isSaving = false;

  // Limpa os controladores quando a tela é destruída para evitar memory leaks
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _nutritionController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  // Método para lidar com o envio do formulário
  Future<void> _submitForm() async {
    // Valida todos os TextFormFields. Se algum retornar uma String (erro), não continua
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final productProvider = context.read<ProductProvider>();

    // Chama o método addProduct do nosso Provider
    final success = await productProvider.addProduct(
      name: _nameController.text, 
      description: _descriptionController.text, 
      nutrition: _nutritionController.text, 
      weight: _weightController.text, 
      price: double.tryParse(_priceController.text) ?? 0.0, 
      imagePath: _imagePathController.text
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Produto adicionado com sucesso!',
            ),
            backgroundColor: Colors.green,
          )
        );
        // Volta para a tela anterior (ProfileScreen)
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Erro ao adicionar o produto.',
            ),
            backgroundColor: Colors.red,
          )
        );
      }
    }

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adicionar Novo Produto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
                    labelText: 'Nome do Produto',
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso/Unidade (ex: 1kg, 355ml)',
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Preço (ex: 7.99)',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Campo obrigatório';
                    if (double.tryParse(value) == null) return 'Por favor, insira um número válido.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imagePathController,
                  decoration: const InputDecoration(
                    labelText: 'Caminho da Imagem (ex: assets/ginger.png)',
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nutritionController,
                  decoration: const InputDecoration(
                    labelText: 'Informação Nutricional',
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isSaving ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)
                  ), 
                  child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text(
                      'Salvar Produto',
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