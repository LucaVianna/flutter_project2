import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../home/presentation/domain/entities/product_model.dart';
import '../../../home/presentation/providers/product_provider.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

// Futuro: importar tela de edição aqui

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  // Função auxiliar para mostrar um diálogo de confirmação antes de excluir
  Future<void> _confirmDelete(BuildContext context, ProductProvider provider, ProductModel product) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Confirmar Exclusão',
        ),
        content: Text(
          'Tem certeza de que deseja excluir o produto "${product.name}"? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false), 
            child: const Text(
              'Cancelar',
            )
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true), 
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text(
              'Excluir',
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await provider.deleteProduct(product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para que a tela se reconstrua quando a lista de produtos do admin mudar
    final productProvider = context.watch<ProductProvider>();
    final allProducts = productProvider.allProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gerenciar Produtos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Adicionar Produto',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AddProductScreen())
              );
            }, 
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (allProducts.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum produto cadastrado.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: allProducts.length,
            itemBuilder: (ctx, index) {
              final product = allProducts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(product.imagePath),
                    onBackgroundImageError: (e, s) => const Icon(Icons.image_not_supported),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ícone de status ATIVO/INATIVO
                      Icon(
                        product.active? Icons.visibility : Icons.visibility_off,
                        color: product.active? Colors.green : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      // Botão de Editar
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => EditProductScreen(productToEdit: product),
                          ));
                        }, 
                      ),
                      // Botão de Excluir
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => _confirmDelete(context, productProvider, product), 
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}