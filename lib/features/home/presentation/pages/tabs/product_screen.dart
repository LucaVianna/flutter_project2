// Caminho lib/features/home/presentation/pages/tabs/product_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product_model.dart';
import '../../providers/cart_provider.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel product;
  
  const ProductScreen({super.key, required this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Acessa o provider aqui também
    final cartProvider = context.read<CartProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.asset(
                    widget.product.imagePath,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ), 
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.product.weight,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey
                        ),
                      ),                      
                    ],
                  ),
                  Icon(Icons.favorite_border, size: 28)
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);                       
                        },
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                  Text(
                    'R\$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ExpansionTile(
                title: Text(
                  'Detalhes do produto',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Nutrições',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      widget.product.nutrition,
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Avaliações',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: List.generate(5, (index) => Icon(Icons.star, color: Colors.amber, size: 24)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),   
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // AÇÃO PRINCIPAL: Usa o provider para adicionar a quantidade certa
                    cartProvider.addToCart(widget.product, quantity: quantity);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(
                        '${widget.product.name} adicionado(a) ao carrinho!',
                      )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // Cor definida no ThemeData
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Adicionar ao Carrinho',
                    style: TextStyle(
                      fontSize: 18,
                      // Cor definida no ThemeData
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), 
    );
  }
}