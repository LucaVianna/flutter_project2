import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../home/presentation/domain/entities/product_model.dart';
import '../../../home/presentation/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
    final ProductModel productToEdit;

    const EditProductScreen({super.key, required this.productToEdit});

    @override
    State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
    final _formKey = GlobalKey<FormState>();

    // Controladores para os campos de texto
    late TextEditingController _nameController;
    late TextEditingController _descriptionController;
    late TextEditingController _nutritionController;
    late TextEditingController _weightController;
    late TextEditingController _priceController;
    late TextEditingController _imagePathController;
    // Novo estado para o switch de 'ativo'
    late bool _isActive;

    bool _isSaving = false;

    @override
    void initState() {
        super.initState();
        // Preenchemos os controladores com os dados do produto que estamos editando
        _nameController = TextEditingController(text: widget.productToEdit.name);
        _descriptionController = TextEditingController(text: widget.productToEdit.description);
        _nutritionController = TextEditingController(text: widget.productToEdit.nutrition);
        _weightController = TextEditingController(text: widget.productToEdit.weight);
        _priceController = TextEditingController(text: widget.productToEdit.price.toString());
        _imagePathController = TextEditingController(text: widget.productToEdit.imagePath);
        _isActive = widget.productToEdit.active;
    }

    @override
    void dispose() {
        // Limpeza dos controladores
        _nameController.dispose();
        _descriptionController.dispose();
        _nutritionController.dispose();
        _weightController.dispose();
        _priceController.dispose();
        _imagePathController.dispose();
        super.dispose();
    }

    Future<void> _submitForm() async {
        if (!_formKey.currentState!.validate()) {
            return;
        }

        setState(() { _isSaving = true; });

        // Cria um novo obj ProductModel com os dados atualizados
        // mas mantendo o ID original
        final updateProduct = ProductModel(
            id: widget.productToEdit.id, // MANTER O ID ORIGINAL 
            name: _nameController.text, 
            description: _descriptionController.text, 
            nutrition: _nutritionController.text, 
            weight: _weightController.text, 
            price: double.tryParse(_priceController.text) ?? 0.0,  
            imagePath: _imagePathController.text,
            active: _isActive,
        );

        // Chama o método 'updateProduct' do nosso provider
        final success = await context.read<ProductProvider>().updateProduct(updateProduct);

        if (mounted) {
            if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Produto atualizado com sucesso!',
                        ), 
                        backgroundColor: Colors.green,
                    ),
                );
                Navigator.of(context).pop();
            } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Erro ao atualizar o produto.',
                        ),
                        backgroundColor: Colors.red,
                    )
                );
            }
        }

        // o setState é chamado aqui caso a tela ainda esteja visível após um erro
        if (mounted) {
            setState(() { _isSaving = false; });
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text(
                    'Editar Produto',
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
                                // Os TextFormFields são os mesmos da tela de adicionar
                                TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                            'Nome do Produto',
                                        ),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                            'Descrição',
                                        ),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                    controller: _weightController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                            'Peso/Unidade',
                                        ),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                    controller: _priceController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                            'Preço',
                                        ),
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                    controller: _imagePathController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                            'Caminho da Imagem',
                                        ),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                    controller: _nutritionController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                            'Informação Nutricional',
                                        ),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
                                ),
                                const SizedBox(height: 16),
                                
                                // --- NOVO: WIDGET SWITCH PARA ATIVAR/DESATIVAR PRODUTO
                                SwitchListTile(
                                    title: const Text(
                                        'Produto Ativo',
                                    ),
                                    subtitle: const Text(
                                        'Se desativado, não aparecerá na loja para os clientes.'
                                    ),
                                    value: _isActive, 
                                    onChanged: (newValue) {
                                        setState(() {
                                            _isActive = newValue;
                                        });
                                    },
                                ),
                                const SizedBox(height: 32),

                                ElevatedButton(
                                    onPressed: _isSaving ? null : _submitForm,
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                    ), 
                                    child: _isSaving
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text('Salvar Alterações')
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}