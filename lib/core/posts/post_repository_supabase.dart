import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yominero/features/posts/domain/post_repository.dart';
import 'package:yominero/shared/models/post.dart';
import 'package:yominero/core/auth/supabase_service.dart';

class PostRepositorySupabase implements PostRepository {
  final SupabaseClient _client = SupabaseService.instance.client;

  @override
  Future<Post> create({
    String? author,
    required String title,
    required String content,
    PostType type = PostType.community,
    List<String> tags = const [],
    List<String> categories = const [],
    List<String>? requiredTags,
    double? budgetAmount,
    String? budgetCurrency,
    DateTime? deadline,
    String? serviceName,
    List<String>? serviceTags,
    double? pricingFrom,
    double? pricingTo,
    String? pricingUnit,
    String? availability,
  }) async {
    final now = DateTime.now().toUtc();
    // Prefer the authenticated user's id when available (RLS expects auth.uid())
    final authUserId = _client.auth.currentUser?.id;
    final authorId = authUserId ?? author;
    if (authorId == null) {
      // If no author could be determined, reject early to avoid DB errors
      throw Exception('Author id required to create post');
    }

    final row = {
      'author_id': authorId,
      'title': title,
      'content': content,
      'type': type.name,
      'tags': tags,
      'categories': categories,
      'required_tags': requiredTags,
      'budget_amount': budgetAmount,
      'budget_currency': budgetCurrency,
      'deadline': deadline?.toUtc().toIso8601String(),
      'service_name': serviceName,
      'service_tags': serviceTags,
      'pricing_from': pricingFrom,
      'pricing_to': pricingTo,
      'pricing_unit': pricingUnit,
      'availability': availability,
      'created_at': now.toIso8601String(),
    };

    final dynamic res = await _client.from('posts').insert(row).select();
    if (res == null) {
      throw Exception('Failed to create post');
    }
    // Supabase may return a List of rows or a Map with 'data'
    dynamic out = res;
    if (res is Map && res.containsKey('data')) {
      out = res['data'];
    }
    final rowMap = (out is List && out.isNotEmpty) ? out.first : out;
    if (rowMap == null) throw Exception('Failed to create post');
    return _mapRowToPost(rowMap as Map<String, dynamic>);
  }

  @override
  Future<List<Post>> getAll() async {
    final dynamic res = await _client
        .from('posts')
        .select('*')
        .order('created_at', ascending: false);
    if (res == null) return [];
    dynamic out = res;
    if (res is Map) {
      final Map m = res;
      if (m.containsKey('data')) out = m['data'];
    }
    final items = (out is List) ? out : <dynamic>[];
    final list = items.cast<Map<String, dynamic>>();
    return list.map(_mapRowToPost).toList();
  }

  @override
  Future<bool> like(String postId, [String? userId]) async {
    // Attempt to insert a like; if conflict (already liked) return false.
    final authUserId = _client.auth.currentUser?.id;
    final uid = userId ?? authUserId;
    if (uid == null) return false;
    final row = {
      'post_id': postId,
      'user_id': uid,
      'created_at': DateTime.now().toUtc().toIso8601String()
    };
    final dynamic res = await _client.from('post_likes').insert(row).select();
    if (res == null) return false;
    dynamic out = res;
    if (res is Map) {
      final Map m = res;
      if (m.containsKey('data')) out = m['data'];
    }
    if (out is List && out.isNotEmpty) return true;
    return false;
  }

  @override
  Future<bool> hasUserLiked(String postId, [String? userId]) async {
    final authUserId = _client.auth.currentUser?.id;
    final uid = userId ?? authUserId;
    if (uid == null) return false;
    final res = await _client
        .from('post_likes')
        .select('id')
        .eq('post_id', postId)
        .eq('user_id', uid)
        .limit(1)
        .maybeSingle();
    return res != null;
  }

  Post _mapRowToPost(Map<String, dynamic> r) {
    final id = r['id']?.toString() ?? '';
    final typeStr = (r['type'] ?? 'community') as String;
    final type = PostType.values
        .firstWhere((t) => t.name == typeStr, orElse: () => PostType.community);
    final createdAt =
        DateTime.tryParse(r['created_at']?.toString() ?? '') ?? DateTime.now();
    return Post(
      id: id,
      type: type,
      authorId: r['author_id']?.toString() ?? '',
      title: r['title']?.toString() ?? '',
      content: r['content']?.toString() ?? '',
      createdAt: createdAt,
      updatedAt: r['updated_at'] != null
          ? DateTime.tryParse(r['updated_at'].toString())
          : null,
      categories:
          (r['categories'] as List?)?.map((e) => e.toString()).toList() ?? [],
      tags: (r['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      imageUrl: r['image_url']?.toString(),
      likes: (r['likes'] is int)
          ? r['likes'] as int
          : int.tryParse(r['likes']?.toString() ?? '0') ?? 0,
      comments: (r['comments'] is int)
          ? r['comments'] as int
          : int.tryParse(r['comments']?.toString() ?? '0') ?? 0,
      active: r['active'] == null
          ? true
          : (r['active'] == true || r['active'].toString() == 'true'),
      requiredTags:
          (r['required_tags'] as List?)?.map((e) => e.toString()).toList(),
      budgetAmount: r['budget_amount'] is num
          ? (r['budget_amount'] as num).toDouble()
          : (r['budget_amount'] != null
              ? double.tryParse(r['budget_amount'].toString())
              : null),
      budgetCurrency: r['budget_currency']?.toString(),
      deadline: r['deadline'] != null
          ? DateTime.tryParse(r['deadline'].toString())
          : null,
      serviceName: r['service_name']?.toString(),
      serviceTags:
          (r['service_tags'] as List?)?.map((e) => e.toString()).toList(),
      pricingFrom: r['pricing_from'] is num
          ? (r['pricing_from'] as num).toDouble()
          : (r['pricing_from'] != null
              ? double.tryParse(r['pricing_from'].toString())
              : null),
      pricingTo: r['pricing_to'] is num
          ? (r['pricing_to'] as num).toDouble()
          : (r['pricing_to'] != null
              ? double.tryParse(r['pricing_to'].toString())
              : null),
      pricingUnit: r['pricing_unit']?.toString(),
      availability: r['availability']?.toString(),
    );
  }
}
