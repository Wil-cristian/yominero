import 'product.dart';

/// Represents an order placed by the user. Each order has an
/// identifier, a list of purchased products, a total cost, and a
/// status indicating its current state (e.g. pendiente, enviado).
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
