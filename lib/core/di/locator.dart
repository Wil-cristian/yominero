import 'package:get_it/get_it.dart';
import 'package:yominero/core/auth/auth_service.dart';
import 'package:yominero/core/groups/group_repository.dart';
import 'package:yominero/features/posts/data/in_memory_post_repository.dart';
import 'package:yominero/features/posts/domain/post_repository.dart';
import 'package:yominero/features/products/data/in_memory_product_repository.dart';
import 'package:yominero/features/products/domain/product_repository.dart';
import 'package:yominero/features/services/data/in_memory_service_repository.dart';
import 'package:yominero/features/services/domain/service_repository.dart';

final sl = GetIt.instance;

void setupLocator() {
  if (sl.isRegistered<AuthService>()) return; // idempotent
  sl.registerLazySingleton<AuthService>(() => AuthService.instance);
  sl.registerLazySingleton<PostRepository>(() => InMemoryPostRepository());
  sl.registerLazySingleton<ProductRepository>(
      () => InMemoryProductRepository());
  sl.registerLazySingleton<ServiceRepository>(
      () => InMemoryServiceRepository());
  sl.registerLazySingleton<GroupRepository>(() => InMemoryGroupRepository());
}
