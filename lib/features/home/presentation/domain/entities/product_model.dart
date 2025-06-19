import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String nutrition;
  final String weight;
  final double price;
  final bool active;
  final String imagePath;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.nutrition,
    required this.weight,
    required this.price,
    required this.active,
    required this.imagePath,
  });

  // Converte o obj ProductModel em um Map, que é o formato que o firestore entende
  // não incluímos 'id' pois ele é o nome do documento
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'nutrition': nutrition,
      'weight': weight,
      'price': price,
      'active': active,
      'imagePath': imagePath,
    };
  }

  // Cria uma instância do ProductModel a partir de um DocumentSnapshot vindo do firestore
  factory ProductModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    // Pega o mapa de dados do documento. O '!' garante que não será nulo
    final data = doc.data()!;

    return ProductModel(
      // O 'id' vem do próprio documento, não dos dados internos
      id: doc.id, 
      // Usamos '??' como um valor padrão para evitar erros se um campo não existir
      name: data['name'] ?? '', 
      description: data['description'] ?? '', 
      nutrition: data['nutrition'] ?? '', 
      weight: data['weight'] ?? '', 
      price: (data['price'] ?? 0.0).toDouble, 
      active: data['active'] ?? false, 
      imagePath: data['imagePath'] ?? '',
    );
  }
}