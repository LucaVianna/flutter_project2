import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/services/order_service.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import 'cart_provider.dart';
import '../../presentation/domain/entities/order_model.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  AuthProvider _authProvider; // Dependência do AuthProvider
  CartProvider _cartProvider; // Dependência do CartProvider

  // Guarda a "inscrição" no nosso stream para podermos cancelá-la depois
  StreamSubscription? _ordersSubscription;

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
  OrderProvider(this._authProvider, this._cartProvider) {
    // Assim que o provider é criado, começa a escutar os pedidos do usuário
    listenToOrders();
  }

  // NOVO MÉTODO: Usado pelo ProxyProvider para atualizar as dependências, sem recriar o objeto inteiro
  void updateDependencies(AuthProvider authProvider, CartProvider cartProvider) {
    _authProvider = authProvider;
    _cartProvider = cartProvider;
  }

  void listenToOrders() {
    _isLoading = true;
    notifyListeners();

    final userId = _authProvider.currentUser?.uid;
    if (userId == null) {
      _isLoading = false;
      _orders = []; // Garante que a lista de pedidos seja limpa no logout
      notifyListeners();
      return;
    }

    // Cancela qualquer escuta anterior para evitar duplicatas
    _ordersSubscription?.cancel();

    // Se inscreve no stream do serviço
    _ordersSubscription = _orderService.getOrdersStream(userId).listen((orders) {
      _orders = orders;
      _isLoading = false;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _error = 'Não foi possível carregar os pedidos';
      _isLoading = false;
      notifyListeners();
    });
  }

  // O createOrder fica mais simples: ele não precisa mais chamar o fetchOrders
  // O stream vai atualizar a lista automaticamente!
  Future<bool> createOrder() async {
    final userId = _authProvider.currentUser?.uid;
    final cartItems = _cartProvider.items;
    final totalPrice = _cartProvider.totalPrice;

    if (userId == null || cartItems.isEmpty) {
      _error = "Usuário não logado ou carrinho vazio.";
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Converte a lista de CartItemModel para uma lista de OrderItemModel
      final orderItems = cartItems
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
    
      // 3. Usa o serviço para salvar o pedido no Firestore
      await _orderService.createOrder(newOrder);
      // LIMPA O CARRINHO
      _cartProvider.clearCart();
      // NÃO PRECISA MAIS CHAMAR fetchOrders AQUI!
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

  // É crucial cancelar a inscrição ao destruir o provider para evitar memory leaks
  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}