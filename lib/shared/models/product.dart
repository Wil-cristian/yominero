class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.inStock = true,
  });
}
