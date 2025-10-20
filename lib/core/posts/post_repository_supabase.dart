import 'package:yominero/features/posts/domain/post_repository.dart';
import 'package:yominero/shared/models/post.dart';
import 'package:yominero/features/posts/data/in_memory_post_repository.dart';

// Stub that delegates to the in-memory repo; kept temporarily for API stability
class PostRepositorySupabase implements PostRepository {
  final InMemoryPostRepository _delegate = InMemoryPostRepository();

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
  }) =>
      _delegate.create(
        author: author,
        title: title,
        content: content,
        type: type,
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

  @override
  Future<List<Post>> getAll() => _delegate.getAll();

  @override
  Future<bool> hasUserLiked(String postId, [String? userId]) =>
      _delegate.hasUserLiked(postId, userId);

  @override
  Future<bool> like(String postId, [String? userId]) =>
      _delegate.like(postId, userId);
}
