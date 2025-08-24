import 'package:yominero/shared/models/post.dart';

/// Abstraction for retrieving and mutating posts.
abstract class PostRepository {
  List<Post> getAll();

  /// Create a post of any type. For simple community post, just leave defaults.
  Post create({
    required String author,
    required String title,
    required String content,
    PostType type,
    List<String> tags,
    List<String> categories,
    // request specific
    List<String>? requiredTags,
    double? budgetAmount,
    String? budgetCurrency,
    DateTime? deadline,
    // offer specific
    String? serviceName,
    List<String>? serviceTags,
    double? pricingFrom,
    double? pricingTo,
    String? pricingUnit,
    String? availability,
  });

  /// Returns true if like was applied, false if user had already liked.
  bool like(String postId, String userId);
  bool hasUserLiked(String postId, String userId);
}
