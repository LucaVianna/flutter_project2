// Caminho lib/features/home/presentation/pages/tabs/shop_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../data/models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import 'product_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  // Lista de produtos agora usando o ProductModel
  // No futuro: viria de um controller ou serviço
  
  // static final List<ProductModel> products = [
  //   ProductModel(id: 'p1', name: 'Maçã', description: 'Fruta fresca e suculenta', nutrition: 'Rica em fibras e vitamina C', weight: '1kg', price: 7.99, active: true, imagePath: 'assets/apple.png'),
  //   ProductModel(id: 'p2', name: 'Coca-Cola', description: 'Refrigerante carbonado', nutrition: 'Açúcares e cafeína', weight: '355ml', price: 11.99, active: true, imagePath: 'assets/coke.png'),
  //   ProductModel(id: 'p3', name: 'Ovo', description: 'Fonte de proteína', nutrition: 'Rico em albumina', weight: '12 unidades', price: 10.99, active: true, imagePath: 'assets/egg.png'),
  //   ProductModel(id: 'p4', name: 'Massa', description: 'Macarrão italiano', nutrition: 'Carboidratos', weight: '500g', price: 6.99, active: true, imagePath: 'assets/pasta.png'),
  //   ProductModel(id: 'p5', name: 'Pepsi', description: 'Refrigerante concorrente', nutrition: 'Açúcares e cafeína', weight: '355ml', price: 11.99, active: true, imagePath: 'assets/pepsi.png'),
  //   ProductModel(id: 'p6', name: 'Sprite', description: 'Refrigerante de limão', nutrition: 'Açúcares', weight: '355ml', price: 11.99, active: true, imagePath: 'assets/sprite.png'),
  // ];

  @override
  Widget build(BuildContext context) {
    // "observar" o ProductProvider para obter a lista de produtos e reagir a mudanças de estado
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Loja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(context, productProvider),
    );
  }

  // Contrói o corpo da tela baseado no estado do ProductProvider
  Widget _buildBody(BuildContext context, ProductProvider provider) {
    // 1. Estado de Carregamento
    if (provider.isShopLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 2. Estado de Erro
    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.error!,
              style: const TextStyle(
                color: Colors.red, 
                fontSize: 16
              ),
              textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => provider.listenToProducts(),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    // 3. Estado de Lista Vazia
    if (provider.products.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum produto encontrado na loja.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // 4. Estado de Sucesso (cm a lista de produtos)
    // Este GridView é contruído com os dados do provider
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: provider.products.length,
        itemBuilder: (context, index) {
          // Percorre a lista dos produtos
          final product = provider.products[index];
          // O Card do produto continua o mesmo, mas agora com dados dinâmicos
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  // Widget para construir o card de um único produto
  Widget _buildProductCard(BuildContext context, ProductModel product) {
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
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            //mainAxisSize: MainAxisSize.min, TALVEZ TIRAR COMENTÁRIO!!!
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
              const SizedBox(height: 8),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.weight,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
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
                        context.read<CartProvider>().addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                            '${product.name} adicionado(a) ao carrinho!'
                          )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ), 
                      child: const Icon(Icons.add, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}         