import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  // Método para facilitar o cálculo do subtotal deste item
  double get subtotal => product.price * quantity;
}