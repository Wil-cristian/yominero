import 'dart:collection';
import 'package:yominero/shared/models/post.dart';
import '../../posts/domain/post_repository.dart';

/// Simple in-memory implementation used for development & tests.
class InMemoryPostRepository implements PostRepository {
  final List<Post> _posts = [
    Post.simple(
      id: 'p1',
      title: 'Primer post',
      content:
          'Descripción del primer post. Esta es una publicación de ejemplo.',
      author: 'Usuario 1',
      createdAt: DateTime.now(),
      likes: 5,
    ),
    Post.simple(
      id: 'p2',
      title: 'Segundo post',
      content: 'Otra descripción para mostrar cómo se ven las publicaciones.',
      author: 'Usuario 2',
      createdAt: DateTime.now(),
      likes: 12,
    ),
    Post.simple(
      id: 'p3',
      title: 'Tercer post',
      content:
          'Publicación de prueba con texto más largo para ocupar espacio y ver el diseño.',
      author: 'Usuario 3',
      createdAt: DateTime.now(),
      likes: 8,
    ),
    // sample request
    Post(
      id: 'r1',
      type: PostType.request,
      authorId: 'Usuario 4',
      title: 'Se requiere técnico para mantenimiento de taladro',
      content: 'Busco técnico certificado para mantenimiento semanal.',
      createdAt: DateTime.now(),
      categories: const ['Maquinaria'],
      tags: const ['taladro', 'mantenimiento'],
      requiredTags: const ['taladro', 'mantenimiento'],
      budgetAmount: 1200,
      budgetCurrency: 'USD',
      likes: 0,
    ),
    // sample offer
    Post(
      id: 'o1',
      type: PostType.offer,
      authorId: 'Usuario 5',
      title: 'Servicio de topografía subterránea',
      content: 'Ofrezco topografía y mapeo con dron especializado.',
      createdAt: DateTime.now(),
      categories: const ['Topografía'],
      tags: const ['topografía', 'mapeo', 'drone'],
      serviceName: 'Topografía subterránea',
      serviceTags: const ['topografía', 'mapeo', 'drone'],
      pricingFrom: 500,
      pricingTo: 2000,
      pricingUnit: 'proyecto',
      availability: 'Lun-Sab 08:00-18:00',
    ),
  ];

  final Map<String, Set<String>> _likesByPost = {}; // postId -> userIds

  @override
  Future<List<Post>> getAll() async => List.unmodifiable(_posts);

  @override
  Future<Post> create({
    required String author,
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
  }) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final now = DateTime.now();
    final Post post;
    if (type == PostType.community) {
      post = Post.simple(
        id: id,
        title: title,
        content: content,
        author: author,
        createdAt: now,
      ).copyWith(tags: tags, categories: categories);
    } else {
      post = Post(
        id: id,
        type: type,
        authorId: author,
        title: title,
        content: content,
        createdAt: now,
        tags: tags,
        categories: categories,
        requiredTags: requiredTags,
        budgetAmount: budgetAmount,
        budgetCurrency: budgetCurrency,
        deadline: deadline,
        serviceName: serviceName,
        serviceTags: serviceTags,
        pricingFrom: pricingFrom,
        pricingTo: pricingTo,
        pricingUnit: pricingUnit,
        availability: availability,
      );
    }
    _posts.insert(0, post);
    return Future.value(post);
  }

  @override
  Future<bool> like(String postId, String userId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return false;
    final likedUsers = _likesByPost.putIfAbsent(postId, () => HashSet());
    if (likedUsers.contains(userId)) return false;
    likedUsers.add(userId);
    final current = _posts[index];
    _posts[index] = current.copyWith(likes: current.likes + 1);
    return true;
  }

  @override
  Future<bool> hasUserLiked(String postId, String userId) async {
    final users = _likesByPost[postId];
    if (users == null) return false;
    return users.contains(userId);
  }
}
