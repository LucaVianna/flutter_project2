import 'package:flutter/foundation.dart';
import '../../../../core/services/order_service.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../presentation/domain/entities/order_model.dart';

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
  Future<void> fetchOrders() async {
    // Pega o ID do usuário através do AuthProvider
    final userId = _authProvider.currentUser?.uid;
    if (userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _orderService.fetchOrders(userId);
    } catch (e) {
      _error = 'Não foi possível carregar os pedidos.';
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Futuramente, teremos um método para criar um pedido
}