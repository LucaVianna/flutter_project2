// Futuramente: import modelo de cupom
import 'package:cloud_firestore/cloud_firestore.dart';

// Enum para garantir que os status sejam sempre consistentes
enum OrderStatus {
  pending,
  shipped,
  delivered,
  cancelled,
}

// Representa um único item dentro de um pedido
class OrderItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final double priceAtTimeOfOrder; // Guarda o preço no momento da compra

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceAtTimeOfOrder,
  });

  // Converte um objeto do OrderItemModel para um Map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'priceAtTimeOfOrder': priceAtTimeOfOrder,
    };
  }

  // Cria um OrderModel a partir de um Map (vindo do Firestore)
  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      priceAtTimeOfOrder: map['priceAtTimeOfOrder']?.toDouble() ?? 0.0,
    );
  }
}

// Representa o pedido completo
class OrderModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double totalPrice;
  final OrderStatus status;
  final String shippingAddress;
  final double shippingPrice;
  final String payMethod; // Ex: "cartão de crédito", "pix"
  // final CouponModel? coupon;
  final String? deliveryImage;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.shippingAddress,
    required this.shippingPrice,
    required this.payMethod,
    // this.coupon,
    this.deliveryImage,
    required this.createdAt,
  });

  // Converte um objeto OrderModel para um Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status.name, // Salva enum como String
      'shippingAddress': shippingAddress,
      'shippingPrice': shippingPrice,
      'payMethod': payMethod,
      'deliveryImage': deliveryImage,
      'createdAt': Timestamp.fromDate(createdAt), // Converte DateTime para Timestamp
    };
  }

  // Cria um OrderModel a partir de um DocumentSnapshot do Firestore
  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      // Converte a lista de Maps de volta para uma lista de OrderModel
      items: (data['items'] as List<dynamic>)
        .map((itemData) => OrderItemModel.fromMap(itemData as Map<String, dynamic>))
        .toList(),
      totalPrice: data['totalPrice']?.toDouble() ?? 0.0,
      // Converte a String de volta para o enum OrderStatus
      status: OrderStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => OrderStatus.pending,
      ),
      shippingAddress: data['shippingAddress'],
      shippingPrice: data['shippingPrice']?.toDouble() ?? 0.0,
      payMethod: data['payMethod'],
      deliveryImage: data['deliveryImage'],
      // Converte o Timestamp do Firestore de volta para DateTime
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}