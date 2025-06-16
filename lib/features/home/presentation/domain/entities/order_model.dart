// Futuramente: import modelo de cupom

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
}