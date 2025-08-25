import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yominero/core/auth/auth_service.dart';
import 'package:yominero/core/groups/group_repository.dart';
import 'package:yominero/features/posts/data/in_memory_post_repository.dart';
import 'package:yominero/features/posts/domain/post_repository.dart';
import 'package:yominero/features/products/data/in_memory_product_repository.dart';
import 'package:yominero/features/products/domain/product_repository.dart';
import 'package:yominero/features/services/data/in_memory_service_repository.dart';
import 'package:yominero/features/services/domain/service_repository.dart';
import 'package:yominero/core/products/product_repository_supabase.dart';
import 'package:yominero/core/posts/post_repository_supabase.dart';

final sl = GetIt.instance;

void setupLocator() {
  if (sl.isRegistered<AuthService>()) return; // idempotent
  sl.registerLazySingleton<AuthService>(() => AuthService.instance);
  // Choose which repositories to register by env variable USE_SUPABASE
  // If USE_SUPABASE is set to 'false' (string), we register the in-memory repos.
  final useSupabase = dotenv.env['USE_SUPABASE'];
  final useSupabaseFlag =
      useSupabase == null || useSupabase.toLowerCase() != 'false';

  if (useSupabaseFlag) {
    sl.registerLazySingleton<PostRepository>(() => PostRepositorySupabase());
    sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositorySupabase());
  } else {
    sl.registerLazySingleton<PostRepository>(() => InMemoryPostRepository());
    sl.registerLazySingleton<ProductRepository>(
        () => InMemoryProductRepository());
  }
  // Also keep the in-memory implementation available by its concrete type
  if (!sl.isRegistered<InMemoryProductRepository>()) {
    sl.registerLazySingleton<InMemoryProductRepository>(
        () => InMemoryProductRepository());
  }
  sl.registerLazySingleton<ServiceRepository>(
      () => InMemoryServiceRepository());
  sl.registerLazySingleton<GroupRepository>(() => InMemoryGroupRepository());
}
