// Caminho lib/features/home/presentation/pages/tabs/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  // O construtor agora é simples e constante. Não recebe mais nada...
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 'watch' observa o CartProvider. Qualquer alteração nele, reconstrói esta tela.
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Center(
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
        ? Center(
          child: Text(
            'Seu carrinho está vazio!',
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
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          item.product.weight,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            // Usa o provider para diminuir a quantidade
                            context.read<CartProvider>().decreaseItemQuantity(item.product.id);
                          },
                        ),
                        Text(
                          '${item.quantity}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
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
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'R\$${item.subtotal.toStringAsFixed(2)}',
                          style: TextStyle(
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
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'R\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ação para finalizar a compra
                      }, 
                      child: Text(
                        'Finalizar Compra'
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}