import '../../features/posts/data/in_memory_post_repository.dart';
import '../../features/posts/domain/post_repository.dart';
import '../../features/products/data/in_memory_product_repository.dart';
import '../../features/products/domain/product_repository.dart';
import '../../features/services/data/in_memory_service_repository.dart';
import '../../features/services/domain/service_repository.dart';

/// Very small service locator. Replace with get_it or provider later if needed.
class Locator {
  static final PostRepository postRepository = InMemoryPostRepository();
  static final ProductRepository productRepository =
      InMemoryProductRepository();
  static final ServiceRepository serviceRepository =
      InMemoryServiceRepository();
}
