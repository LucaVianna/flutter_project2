import 'package:cloud_firestore/cloud_firestore.dart';

enum CouponType { percentage, fixed }

class CouponModel {
  final String id;
  final String code;
  final double discountValue;
  final CouponType type;
  final bool isActive;

  CouponModel({
    required this.id,
    required this.code,
    required this.discountValue,
    required this.type,
    required this.isActive,
  });

  factory CouponModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CouponModel(
      id: doc.id, 
      code: doc['code'] ?? '', 
      discountValue: (data['discountValue'] ?? 0).toDouble(), 
      type: (data['type'] == 'percentage') ? CouponType.percentage : CouponType.fixed, 
      isActive: data['isActive'] ?? false,
    );
  }
}