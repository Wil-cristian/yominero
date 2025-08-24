import 'package:yominero/shared/models/product.dart';

abstract class ProductRepository {
  List<Product> getAll();
  Product? getById(String id);
}
