// lib/core/services/product_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/home/presentation/domain/entities/product_model.dart';

// Serviço para gerenciar as operações de produtos no Firestore
class ProductService {
  // Referência para a coleção 'products' no Firestore
  final CollectionReference<Map<String, dynamic>> _productCollection = FirebaseFirestore.instance.collection('products');

  // Adiciona um novo produto ao Firestore
  // O 'id' será gerado automaticamente pelo Firestore
  Future<void> addProduct(ProductModel product) async {
    try {
      // Usamos .add() com o mapa do nosso objeto produto
      // O 'id' não é salvo no documento, pois ele já é o identificador do documento
      await _productCollection.add(product.toMap());
    } catch (e) {
      print('Erro ao adicionar produto: $e');
      // Relança o erro para que a camada de provider possa tratá-lo
      rethrow;
    }
  }

  // Retorna um Stream (transmissão ao vivo) da lista de produtos ativos
  // A UI se atualizará automaticamente se um produto for adicionado ou alterado
  Stream<List<ProductModel>> getProductsStream() {
    // Criamos uma consulta que busca apenas produtos onde o campo 'active' é true
    final query = _productCollection.where('active', isEqualTo: true);

    // .snapshots() escuta as mudanças em tempo real
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Usamos o nosso factory constructor para converter os dados do Firestore em um obj ProductModel
        return ProductModel.fromFirestore(doc);
      }).toList();
    });
  }
}