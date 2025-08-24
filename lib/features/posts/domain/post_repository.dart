import 'package:yominero/shared/models/post.dart';

/// Abstraction for retrieving and mutating posts.
abstract class PostRepository {
  List<Post> getAll();

  /// Creates and returns a new post (inserted at the beginning).
  Post create(
      {required String author, required String title, required String content});

  /// Returns true if like was applied, false if user had already liked.
  bool like(String postId, String userId);
  bool hasUserLiked(String postId, String userId);
}
