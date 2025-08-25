import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/core/products/product_mapper.dart';
import 'package:yominero/shared/models/product.dart';

void main() {
  test('mapRowToProduct maps fields correctly', () {
    final row = {
      'id': 123,
      'name': 'Test Product',
      'description': 'Desc',
      'price': '99.5',
      'image_url': 'http://img',
      'in_stock': 1,
    };

    final p = mapRowToProduct(row);

    expect(p, isA<Product>());
    expect(p.id, '123');
    expect(p.name, 'Test Product');
    expect(p.description, 'Desc');
    expect(p.price, 99.5);
    expect(p.imageUrl, 'http://img');
    expect(p.inStock, true);
  });
}
