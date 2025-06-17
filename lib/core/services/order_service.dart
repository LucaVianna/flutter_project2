import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/home/presentation/domain/entities/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Coleção onde os pedidos serão armazenados
  late final CollectionReference<Map<String, dynamic>> _ordersCollection = _firestore.collection('orders');

  // Cria um novo pedido no Firestore
  Future<void> createOrder(OrderModel order) async {
    try {
      await _ordersCollection.add(order.toMap());
    } catch (e) {
      print('Erro ao criar pedido: $e');
      rethrow;
    }
  }

  // Busca a lista de pedidos de um usuário específico
  Future<List<OrderModel>> fetchOrders(String userId) async {
    try {
      final querySnapshot = await _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true) // Ordena pelos mais recentes
        .get();

      // Converte cada documento em um OrderModel
      return querySnapshot.docs
        .map((doc) => OrderModel.fromFirestore(doc))
        .toList();
    } catch (e) {
      print('Erro ao buscar pedidos: $e');
      return [];
    }
  }
}