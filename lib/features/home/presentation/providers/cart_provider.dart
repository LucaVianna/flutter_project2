import 'package:flutter/foundation.dart';
import '../domain/entities/cart_item_model.dart';
import '../domain/entities/product_model.dart';

class CartProvider with ChangeNotifier {
  // Lista privada de itens no carrinho
  final List<CartItemModel> _items = [];

  // Getter público para acessar a lista de itens (leitura)
  List<CartItemModel> get items => _items;

  // Getter para o número de itens únicos no carrinno
  int get itemCount => _items.length;

  // Getter para o preço total do carrinho
  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.subtotal;
    }
    return total;
  }

  // Método para adicionar um produto ao carrinho
  void addToCart(ProductModel product, {int quantity = 1}) {
    // Tenta encontrar o item no carrinho pelo ID do produto
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // Se o index já existe, apenas aumenta a quantidade
      _items[index].quantity += quantity;
    } else {
      // Se não existe, adiciona um novo CartItemModel à lista
      _items.add(CartItemModel(product: product, quantity: quantity));
    }

    // Notifica os widgets que estão ouvindo sobre a mudança
    notifyListeners();
  }

  // Método para remover um item completamente do carrinho
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Método para aumentar a quantidade de um item
  void increaseItemQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // Método para diminuir a quantidade de um item
  void decreaseItemQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        removeFromCart(productId);
      }
      notifyListeners();
    }
  }

  // Método para limpar o carrinho completamente
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}