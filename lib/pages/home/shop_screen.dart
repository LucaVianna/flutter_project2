import 'package:flutter/material.dart';
import './product_screen.dart';

class ShopScreen extends StatefulWidget {
  final Function(Map<String, dynamic>, int) addToCart;

  ShopScreen({required this.addToCart});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // Define uma lista de produtos
  final List<Map<String, dynamic>> products = [
    {'name': 'Maçã', 'price': 7.99, 'descricao': '1kg', 'image': 'assets/apple.png'},
    {'name': 'Coca-Cola', 'price': 11.99, 'descricao': '355ml', 'image': 'assets/coke.png'},
    {'name': 'Coca-Cola Diet', 'price': 11.99, 'descricao': '355ml', 'image': 'assets/cokeDiet.png'},
    {'name': 'Ovo', 'price': 10.99, 'descricao': '1.5kg', 'image': 'assets/egg.png'},
    {'name': 'Pasta', 'price': 6.99, 'descricao': '0.5kg', 'image': 'assets/pasta.png'},
    {'name': 'Pepsi', 'price': 11.99, 'descricao': '355ml', 'image': 'assets/pepsi.png'},
    {'name': 'Sprite', 'price': 11.99, 'descricao': '355ml', 'image': 'assets/sprite.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Shopping',
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
                    builder: (context) => ProductScreen(
                      product: product,
                      addToCart: widget.addToCart,
                    ))
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
                            product['image'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),                      
                      SizedBox(height: 8),

                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product['descricao'],
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
                            'R\$${product['price'].toStringAsFixed(2)}',
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
                                widget.addToCart({...product}, 1);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${product['name']} adicionado(a) ao carrinho!'))
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 20,
                              ),
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
        ),
      ),
    );
  }
}