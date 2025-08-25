import 'package:yominero/shared/models/product.dart';

Product mapRowToProduct(Map<String, dynamic> r) {
  return Product(
    id: r['id']?.toString() ?? '',
    name: r['name']?.toString() ?? 'No name',
    description: r['description']?.toString() ?? '',
    price: double.tryParse(r['price']?.toString() ?? '0') ?? 0.0,
    imageUrl: r['image_url']?.toString(),
    inStock: (r['in_stock'] == null)
        ? true
        : (r['in_stock'] == true || r['in_stock'].toString() == '1'),
  );
}
