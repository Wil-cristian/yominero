import 'dart:collection';
import 'package:yominero/shared/models/post.dart';
import '../../posts/domain/post_repository.dart';

/// Simple in-memory implementation used for development & tests.
class InMemoryPostRepository implements PostRepository {
  final List<Post> _posts = [
    Post(
      id: 'p1',
      title: 'Primer post',
      content:
          'Descripción del primer post. Esta es una publicación de ejemplo.',
      author: 'Usuario 1',
      createdAt: DateTime.now(),
      likes: 5,
    ),
    Post(
      id: 'p2',
      title: 'Segundo post',
      content: 'Otra descripción para mostrar cómo se ven las publicaciones.',
      author: 'Usuario 2',
      createdAt: DateTime.now(),
      likes: 12,
    ),
    Post(
      id: 'p3',
      title: 'Tercer post',
      content:
          'Publicación de prueba con texto más largo para ocupar espacio y ver el diseño.',
      author: 'Usuario 3',
      createdAt: DateTime.now(),
      likes: 8,
    ),
  ];

  final Map<String, Set<String>> _likesByPost = {}; // postId -> userIds

  @override
  List<Post> getAll() => List.unmodifiable(_posts);

  @override
  Post create(
      {required String author,
      required String title,
      required String content}) {
    final post = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      author: author,
      createdAt: DateTime.now(),
      likes: 0,
      comments: 0,
    );
    _posts.insert(0, post); // newest first
    return post;
  }

  @override
  @override
  bool like(String postId, String userId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return false;
    final likedUsers = _likesByPost.putIfAbsent(postId, () => HashSet());
    if (likedUsers.contains(userId)) return false;
    likedUsers.add(userId);
    final current = _posts[index];
    _posts[index] = Post(
      id: current.id,
      title: current.title,
      content: current.content,
      author: current.author,
      createdAt: current.createdAt,
      imageUrl: current.imageUrl,
      comments: current.comments,
      likes: current.likes + 1,
    );
    return true;
  }

  @override
  bool hasUserLiked(String postId, String userId) {
    final users = _likesByPost[postId];
    if (users == null) return false;
    return users.contains(userId);
  }
}
