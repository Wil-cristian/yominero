import 'product.dart';

class Order {
  final String id;
  final List<Product> items;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
  });
}
