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
}