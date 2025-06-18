import 'package:flutter/foundation.dart';
import '../../../../core/services/order_service.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../presentation/domain/entities/order_model.dart';
import 'package:nectar_online_groceries/features/home/presentation/domain/entities/cart_item_model.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  final AuthProvider _authProvider; // Dependência do AuthProvider

  // ESTADOS INTERNOS
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  // GETTERS PÚBLICOS
  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Construtor recebe o AuthProvider
  // Injeção de Dependência
  OrderProvider(this._authProvider) {
    // Se já houver um usuário logado quando o provider for criado, busca os pedidos
    if (_authProvider.currentUser != null) {
      fetchOrders();
    }
  }

  // Busca os pedidos do usuário logado no Firestore
  // O parâmetro 'setLoading' nos permite chamá-lo silenciosamente de outros métodos
  Future<void> fetchOrders({bool setLoading = true}) async {
    // Pega o ID do usuário através do AuthProvider
    final userId = _authProvider.currentUser?.uid;
    if (userId == null) return;

    if (setLoading) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      _orders = await _orderService.fetchOrders(userId);
    } catch (e) {
      _error = 'Não foi possível carregar os pedidos.';
      _orders = [];
    } finally {
      if (setLoading) {
        _isLoading = false;
        notifyListeners();
      } else {
        // Se não era para mostrar o loading, apenas notifica que os dados (a lista de pedidos) mudaram
        notifyListeners();
      }
    }
  }

  // Cria um novo pedido a partir dos itens do carrinho
  Future<bool> createOrder({
    required List<CartItemModel> items,
    required double totalPrice,
  }) async {
    // Pega o ID do usuário logado. Se não houver, a ação falha
    final userId = _authProvider.currentUser?.uid;
    if (userId == null || items.isEmpty) {
      _error = "Usuário não logado ou carrinho vazio.";
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    // 1. Converte a lista de CartItemModel para uma lista de OrderItemModel
    final orderItems = items
      .map((cartItems) => OrderItemModel(
        productId: cartItems.product.id, 
        productName: cartItems.product.name, 
        quantity: cartItems.quantity, 
        priceAtTimeOfOrder: cartItems.product.price
      ))
      .toList();

    // 2. Cria um objeto OrderModel com os dados
    final newOrder = OrderModel(
      id: '', // Firestore gera ID do documento automaticamente
      userId: userId, 
      items: orderItems, 
      totalPrice: totalPrice, 
      status: OrderStatus.pending,
      // Usando dados fixos por enquanto para o endereço e frete 
      shippingAddress: 'Rua Atibaia 1, São Paulo (SP)', 
      shippingPrice: 15.00, 
      payMethod: 'Pix', 
      createdAt: DateTime.now(),
    );

    try {
      // 3. Usa o serviço para salvar o pedido no Firestore
      await _orderService.createOrder(newOrder);
      // 4. Chama o fetchOrders de forma "silenciosa", sem que ele mostre seu próprio loading
      await fetchOrders(setLoading: false);
      return true;
    } catch (e) {
      _error = "Ocorreu um erro ao criar o seu pedido";
      return false;
    } finally {
      // Garante que o loading da ação de criar pedido termine
      _isLoading = false;
      notifyListeners();
    }
  }
}