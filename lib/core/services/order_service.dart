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

  // NOVO: Retorna um "vídeo ao vivo" (Stream) dos pedidos do usuário
  Stream<List<OrderModel>> getOrdersStream(String userId) {
    // .snapshots() é a chave aqui. Ele escuta as mudanças em tempo real
    final snapshots = _ordersCollection
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true) // Ordena pelos mais recentes
      .snapshots();

    // usamos .map para transformar o stream de 'QuerySnapshot' do Firebase em um stream da nossa lista de 'OrderModel'
    return snapshots.map((snapshot) {
      return snapshot.docs
        .map((doc) => OrderModel.fromFirestore(doc))
        .toList();
    });
  }

  // --- NOVO MÉTODO: (UPDATE) ---
  // Atualiza apenas o status de um pedido específico no Firestore
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      // Usamos .doc(orderId).update() para editar campos específicos de um documento
      await _ordersCollection.doc(orderId).update({
      // O Firestore espera um Map dos campos a serem alterados
      // Usamos .name para converter nosso enum 'OrderStatus' em string
        'status': newStatus.name
      });
    } catch (e) {
      print('Erro ao atualizar o status do pedido: $e');
      rethrow;
    }
  }

  // --- NOVO MÉTODO: (READ para ADMIN) ---
  // Retorna o Stream de TODOS os pedidos para a tela de gerenciamento (mais recentes primero)
  Stream<List<OrderModel>> getAllOrdersStreamForAdmin() {
    final query = _ordersCollection.orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    });
  }
}