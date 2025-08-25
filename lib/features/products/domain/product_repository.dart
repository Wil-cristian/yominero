import 'package:yominero/shared/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product?> getById(String id);
}
