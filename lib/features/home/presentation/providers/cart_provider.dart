import 'package:flutter/foundation.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../data/models/product_model.dart';

import '../../../../data/models/coupon_model.dart';
import '../../../../data/services/coupon_service.dart';

class CartProvider with ChangeNotifier { 
  // --- MUDANÇA PRINCIPAL: USAMOS UM MAP ONDE A CHAVE É O ID DO PRODUTO (Lista privada de itens no carrinho)
  final Map<String, CartItemModel> _items = {};
  // --- ESTADO DO CUPOM
  CouponModel? _appliedCoupon;
  final CouponService _couponService = CouponService(); // NOVA INSTÂNCIA

  // O Getter agora converte os valores do mapa em uma lista
  List<CartItemModel> get items => _items.values.toList();
  // O Getter para o cupom
  CouponModel? get appliedCoupon => _appliedCoupon;

  // Getter para o número de itens únicos no carrinno
  int get itemCount => _items.length;

  // Getter para o subtotal (soma dos preços sem desconto)
  double get subtotalPrice {
    var total = 0.0;
    // Itera sobre o mapa para calcular o total
    _items.forEach((key, cartItem) {
      total += cartItem.subtotal;
    });
    return total;
  }

  // Getter para o total final (com desconto)
  double get totalPrice {
    double total = subtotalPrice;
    if (_appliedCoupon != null) {
      if (_appliedCoupon!.type == CouponType.percentage) {
        total -= total * (_appliedCoupon!.discountValue / 100);
      } else if (_appliedCoupon!.type == CouponType.fixed) {
        total -= _appliedCoupon!.discountValue;
      }
    }
    return total < 0 ? 0 : total;
  }

  // Método para adicionar um produto ao carrinho
  void addToCart(ProductModel product, {int quantity = 1}) {
    // Econtrar o item no carrinho pelo ID do produto
    if (_items.containsKey(product.id)) {
      // Se o item já existe, apenas atualiza a quantidade
      _items.update(
        product.id,
        (existingItem) => CartItemModel(
          product: existingItem.product,
          quantity: existingItem.quantity + quantity,
        )
      );
    } else {
      // Se não existe, adiciona uma nova entrada no mapa
      _items.putIfAbsent(
        product.id,
        () => CartItemModel(
          product: product,
          quantity: quantity,
        ) 
      );
    }
    notifyListeners();
  }

  // Método para remover um item completamente do carrinho (pelo seu ID)
  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Método para aumentar a quantidade de um item (pelo seu ID)
  void increaseItemQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (item) => CartItemModel(
        product: item.product,
        quantity: item.quantity + 1,
      ));
      notifyListeners();
    }
  }
  

  // Método para diminuir a quantidade de um item (pelo seu ID)
  void decreaseItemQuantity(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items.update(productId, (item) => CartItemModel(
          product: item.product,
          quantity: item.quantity - 1,
        ));
      } else {
        _items.remove(productId);
      }
    }
  }

  // --- NOVOS MÉTODOS DE CUPOM ---

  // Tenta aplicar cupom ao carrinho
  // Retorna mensagem de sucesso ou erro
  Future<String> applyCoupon(String code) async {
    // Busca pelo cupom no Firestore
    final coupon = await _couponService.getCouponByCode(code.trim().toUpperCase());

    if (coupon == null) {
      return 'Cupom inválido ou não encontrado';
    }

    if (!coupon.isActive) {
      return 'Este cupom não está mais ativo';
    }

    // Se tudo estiver certo, aplica o cupom e notifica a UI
    _appliedCoupon = coupon;
    notifyListeners();
    return 'Cupom "${coupon.code}" aplicado com sucesso!';
  }

  // Remove o cupom aplicado
  void removeCoupon() {
    if (_appliedCoupon != null) {
      _appliedCoupon = null;
      notifyListeners();
    }
  }

  // Método para limpar o carrinho completamente
  void clearCart() {
    _items.clear();
    _appliedCoupon = null;
    notifyListeners();
  }
}