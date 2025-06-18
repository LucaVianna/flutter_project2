// Caminho lib/features/home/presentation/pages/tabs/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:nectar_online_groceries/features/home/presentation/providers/order_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  @override
  Widget build(BuildContext context) {
    // 'watch' observa o CartProvider. Qualquer alteração nele, reconstrói esta tela.
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Meu Carrinho',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: cartItems.isEmpty
        // Se o carrinho estiver vazio, mostra uma mensagem
        ? const Center(
          child: Text(
            'Seu carrinho está vazio.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.asset(
                      item.product.imagePath,
                      width: 50,
                      height: 50,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          item.product.weight,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            // Usa o provider para diminuir a quantidade
                            context.read<CartProvider>().decreaseItemQuantity(item.product.id);
                          },
                        ),
                        Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            // Usa o provider para aumentar a quantidade
                            context.read<CartProvider>().increaseItemQuantity(item.product.id);
                          },
                        ),
                      ],
                    ), 
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Usa o provider para remover o item
                            context.read<CartProvider>().removeFromCart(item.product.id);
                          },
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'R\$${item.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),  
                  ),
                );
              },
            ),
          ),
          // --- CARD DE RESUMO DO PEDIDO ---
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'R\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // Desabilita o botão se o OrderProvider estiver carregando
                      onPressed: (context.watch<OrderProvider>().isLoading)
                        ? null
                        : () async {
                          // --- Captura o que precisa ANTES do await
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          // Pega as instâncias do provider necessário
                          final orderProvider = context.read<OrderProvider>();

                          //Chama o método para criar o pedido
                          final success = await orderProvider.createOrder();

                          // Se o widget ainda estiver montado na árvore
                          if (!mounted) return;

                          if (success) {
                            // Mostra uma mensagem de sucesso
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text('Pedido realizado com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            // Mostra uma mensagem de erro se algo falhar
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  orderProvider.error ?? 'Erro desconhecido.'
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }, 
                      child: (context.watch<OrderProvider>().isLoading)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Finalizar Compra'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}