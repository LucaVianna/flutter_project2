import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coupon_model.dart';

class CouponService {
  final CollectionReference _couponsCollection = FirebaseFirestore.instance.collection('coupons');

  // Busca um cupom no Firestore pel o seu código
  // Retorna um CouponModel se encontrar, ou null se não encontrar
  Future<CouponModel?> getCouponByCode(String code) async {
    try {
      final querySnapshot = await _couponsCollection
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return CouponModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      print('Erro ao buscar cupom: $e');
      return null;
    }
  }
}