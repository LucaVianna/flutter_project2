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
}