import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../auth/supabase_service.dart';
import 'package:yominero/features/products/domain/product_repository.dart';
import 'package:yominero/shared/models/product.dart';
import 'product_mapper.dart';

class ProductRepositorySupabase implements ProductRepository {
  final SupabaseClient _client = SupabaseService.instance.client;

  @override
  Future<List<Product>> getAll() async {
    try {
      final res = await _client.from('products').select();
      final dynamic raw =
          res is Map && res.containsKey('data') ? res['data'] : res;
      final data = raw as List<dynamic>?;
      if (data == null) return [];
      final list =
          data.map((e) => mapRowToProduct(e as Map<String, dynamic>)).toList();
      // write cache
      try {
        await _writeCache(list);
      } catch (_) {}
      return list;
    } catch (e) {
      // on error, try reading cache
      try {
        final cached = await _readCache();
        if (cached != null) return cached;
      } catch (_) {}
      rethrow;
    }
  }

  @override
  Future<Product?> getById(String id) async {
    try {
      final res = await _client.from('products').select().eq('id', id).limit(1);
      final dynamic raw =
          res is Map && res.containsKey('data') ? res['data'] : res;
      final data = raw as List<dynamic>?;
      if (data == null || data.isEmpty) return null;
      return mapRowToProduct(data.first as Map<String, dynamic>);
    } catch (e) {
      // fallback to cache
      final cached = await _readCache();
      if (cached == null) rethrow;
      for (final p in cached) {
        if (p.id == id) return p;
      }
      return null;
    }
  }

  Future<File> _cacheFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/products_cache.json');
  }

  Future<void> _writeCache(List<Product> list) async {
    final file = await _cacheFile();
    final jsonList = list
        .map((p) => {
              'id': p.id,
              'name': p.name,
              'description': p.description,
              'price': p.price,
              'image_url': p.imageUrl,
              'in_stock': p.inStock ? 1 : 0,
            })
        .toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<List<Product>?> _readCache() async {
    try {
      final file = await _cacheFile();
      if (!file.existsSync()) return null;
      final txt = await file.readAsString();
      final data = jsonDecode(txt) as List<dynamic>;
      return data
          .map((e) => mapRowToProduct(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }
}
