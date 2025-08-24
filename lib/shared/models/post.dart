enum PostType { community, request, offer }

class Post {
  final String id;
  final PostType type;
  final String authorId;
  final String title;
  final String content; // renamed from body to keep existing uses
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> categories;
  final List<String> tags;
  final String? imageUrl;
  final int likes;
  final int comments;
  final bool active;

  // Request specific
  final List<String>? requiredTags;
  final double? budgetAmount;
  final String? budgetCurrency;
  final DateTime? deadline;

  // Offer specific
  final String? serviceName;
  final List<String>? serviceTags;
  final double? pricingFrom;
  final double? pricingTo;
  final String? pricingUnit;
  final String? availability; // simplified text representation

  const Post({
    required this.id,
    required this.type,
    required this.authorId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.categories = const [],
    this.tags = const [],
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.active = true,
    this.requiredTags,
    this.budgetAmount,
    this.budgetCurrency,
    this.deadline,
    this.serviceName,
    this.serviceTags,
    this.pricingFrom,
    this.pricingTo,
    this.pricingUnit,
    this.availability,
  });

  Post copyWith({
    PostType? type,
    String? authorId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? categories,
    List<String>? tags,
    String? imageUrl,
    int? likes,
    int? comments,
    bool? active,
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
  }) => Post(
        id: id,
        type: type ?? this.type,
        authorId: authorId ?? this.authorId,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        categories: categories ?? this.categories,
        tags: tags ?? this.tags,
        imageUrl: imageUrl ?? this.imageUrl,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        active: active ?? this.active,
        requiredTags: requiredTags ?? this.requiredTags,
        budgetAmount: budgetAmount ?? this.budgetAmount,
        budgetCurrency: budgetCurrency ?? this.budgetCurrency,
        deadline: deadline ?? this.deadline,
        serviceName: serviceName ?? this.serviceName,
        serviceTags: serviceTags ?? this.serviceTags,
        pricingFrom: pricingFrom ?? this.pricingFrom,
        pricingTo: pricingTo ?? this.pricingTo,
        pricingUnit: pricingUnit ?? this.pricingUnit,
        availability: availability ?? this.availability,
      );

  /// Backwards helper for older simple constructor usage.
  factory Post.simple({
    required String id,
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
    String? imageUrl,
    int likes = 0,
    int comments = 0,
  }) => Post(
        id: id,
        type: PostType.community,
        authorId: author,
        title: title,
        content: content,
        createdAt: createdAt,
        imageUrl: imageUrl,
        likes: likes,
        comments: comments,
      );
}
