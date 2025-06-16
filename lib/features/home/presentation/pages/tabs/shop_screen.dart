// Caminho lib/features/home/presentation/pages/tabs/shop_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product_model.dart';
import '../../providers/cart_provider.dart';
import 'product_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  // Lista de produtos agora usando o ProductModel
  // No futuro: viria de um controller ou serviço
  
  static final List<ProductModel> products = [
    ProductModel(id: 'p1', name: 'Maçã', description: 'Fruta fresca e suculenta', nutrition: 'Rica em fibras e vitamina C', weight: '1kg', price: 7.99, active: true, imagePath: 'assets/apple.png'),
    ProductModel(id: 'p2', name: 'Coca-Cola', description: 'Refrigerante carbonado', nutrition: 'Açúcares e cafeína', weight: '355ml', price: 11.99, active: true, imagePath: 'assets/coke.png'),
    ProductModel(id: 'p3', name: 'Ovo', description: 'Fonte de proteína', nutrition: 'Rico em albumina', weight: '12 unidades', price: 10.99, active: true, imagePath: 'assets/egg.png'),
    ProductModel(id: 'p4', name: 'Massa', description: 'Macarrão italiano', nutrition: 'Carboidratos', weight: '500g', price: 6.99, active: true, imagePath: 'assets/pasta.png'),
    ProductModel(id: 'p5', name: 'Pepsi', description: 'Refrigerante concorrente', nutrition: 'Açúcares e cafeína', weight: '355ml', price: 11.99, active: true, imagePath: 'assets/pepsi.png'),
    ProductModel(id: 'p6', name: 'Sprite', description: 'Refrigerante de limão', nutrition: 'Açúcares', weight: '355ml', price: 11.99, active: true, imagePath: 'assets/sprite.png'),
  ];

  @override
  Widget build(BuildContext context) {
    // Acessa o CartProvider que está na árvore de widgets
    final cartProvider = context.read<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Loja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            // Percorre a lista dos produtos
            final product = products[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Navega para a ProductScreen passando o ProductModel
                    builder: (context) => ProductScreen(product: product),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            product.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),                      
                      SizedBox(height: 8),
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.weight,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'R\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                // AÇÃO PRINCIPAL: Usa o provider para adicionar ao carrinho
                                cartProvider.addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                    '${product.name} adicionado(a) ao carrinho!'
                                  )),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ), 
                              child: Icon(Icons.add, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}