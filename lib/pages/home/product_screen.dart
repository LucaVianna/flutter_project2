import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>, int) addToCart;

  ProductScreen({required this.product, required this.addToCart});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
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
                    widget.product['image'],
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
                        widget.product['name'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.product['descricao'],
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
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });                         
                          }
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
                        onPressed: () {
                          setState(() {
                              quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    'R\$${widget.product['price'].toStringAsFixed(2)}',
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
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus fermentum nunc et ex sagittis cursus.',
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
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus fermentum nunc et ex sagittis cursus.',
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
                    widget.addToCart(widget.product, quantity);
                    Navigator.pop(context);
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