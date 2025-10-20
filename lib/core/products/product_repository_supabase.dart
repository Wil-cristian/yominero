import 'package:yominero/features/products/domain/product_repository.dart';
import 'package:yominero/shared/models/product.dart';
import 'package:yominero/features/products/data/in_memory_product_repository.dart';

// Stub delegating to in-memory implementation to keep API stable
class ProductRepositorySupabase implements ProductRepository {
  final InMemoryProductRepository _delegate = InMemoryProductRepository();

  @override
  Future<List<Product>> getAll() => _delegate.getAll();

  @override
  Future<Product?> getById(String id) => _delegate.getById(id);
}
