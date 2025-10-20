import 'package:flutter/material.dart';
import 'core/theme/colors.dart';
import 'core/auth/auth_service.dart';
import 'package:yominero/shared/models/post.dart';
import 'core/routing/app_router.dart';
import 'core/di/locator.dart';
import 'features/posts/domain/post_repository.dart';
import 'features/posts/ui/post_creation_sheet.dart';
import 'core/matching/match_engine.dart';
import 'core/matching/suggestion_cache.dart';
import 'core/theme/animations.dart';
import 'core/theme/glass_card.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late final PostRepository _repo;
  late List<Post> _posts;
  String _query = '';
  PostSort _sort = PostSort.recent;
  List<MatchResult> _suggestions = [];
  final Map<String, int> _suggestionScores = {};
  final Map<String, bool> _likesCache = {};

  @override
  void initState() {
    super.initState();
    _repo = sl<PostRepository>();
    _posts = [];
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _repo
          .getAll()
          .timeout(const Duration(seconds: 8), onTimeout: () => <Post>[]);
      _posts = posts;
      final user = AuthService.instance.currentUser;
      _likesCache.clear();
      if (user != null) {
        // populate likes cache (simple per-post checks)
        for (final p in _posts) {
          try {
            final liked = await _repo.hasUserLiked(p.id, user.id);
            _likesCache[p.id] = liked;
          } catch (_) {
            _likesCache[p.id] = false;
          }
        }
      }
      _computeSuggestions();
      if (mounted) setState(() {});
    } catch (e) {
      // keep previous list on error
      if (mounted) setState(() {});
    }
  }

  void _computeSuggestions() {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      _suggestions = [];
      return;
    }
    final signature = buildPostSignature(_posts);
    _suggestions = SuggestionCache.instance.getOrCompute(
      userId: user.id,
      signature: signature,
      builder: () {
        final reqs = MatchEngine.requestsForUser(user, _posts, threshold: 30);
        final opps =
            MatchEngine.opportunitiesForUser(user, _posts, threshold: 30);
        final byId = <String, MatchResult>{};
        for (final r in [...reqs, ...opps]) {
          final existing = byId[r.post.id];
          if (existing == null || r.score > existing.score) {
            byId[r.post.id] = r;
          }
        }
        final all = byId.values.toList();
        all.sort((a, b) => b.score.compareTo(a.score));
        return all.take(10).toList();
      },
    );
    _suggestionScores
      ..clear()
      ..addEntries(_suggestions.map((m) => MapEntry(m.post.id, m.score)));
  }

  List<Post> _filteredSorted() {
    var list = List<Post>.from(_posts);
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.content.toLowerCase().contains(q))
          .toList();
    }
    list.sort((a, b) => _sort == PostSort.popular
        ? b.likes.compareTo(a.likes)
        : b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Map<String, List<Post>> _group(List<Post> posts) {
    final map = <String, List<Post>>{};
    for (final p in posts) {
      final d = DateTime(p.createdAt.year, p.createdAt.month, p.createdAt.day);
      final key = _humanDate(d);
      map.putIfAbsent(key, () => []).add(p);
    }
    return map;
  }

  String _humanDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final base = DateTime(date.year, date.month, date.day);
    if (base == today) return 'Hoy';
    if (base == yesterday) return 'Ayer';
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  Future<void> _likePost(Post post) async {
    final idx = _posts.indexWhere((p) => p.id == post.id);
    if (idx == -1) return;
    final user = AuthService.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para dar like.')),
      );
      return;
    }
    final applied = await _repo.like(post.id, user.id);
    if (!applied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ya le diste like a este post.')),
        );
      }
      return;
    }
    // optimistically update local state
    if (!mounted) return;
    setState(() {
      final current = _posts[idx];
      _posts[idx] = current.copyWith(likes: current.likes + 1);
      _likesCache[post.id] = true;
      _computeSuggestions();
    });
  }

  void _openCreatePost() {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicia sesión para publicar.')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => PostCreationSheet(
        authorName: user.name,
        create: ({
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
          return _repo.create(
            author: author,
            title: title,
            content: content,
            type: type,
            tags: tags,
            categories: categories,
            requiredTags: requiredTags,
            budgetAmount: budgetAmount,
            budgetCurrency: budgetCurrency,
            serviceName: serviceName,
            serviceTags: serviceTags,
            pricingFrom: pricingFrom,
            pricingTo: pricingTo,
            pricingUnit: pricingUnit,
            availability: availability,
          );
        },
        onCreated: (post) async {
          _query = '';
          _sort = PostSort.recent;
          // Invalidate cache for current user to force recompute next access
          final u = AuthService.instance.currentUser;
          if (u != null) SuggestionCache.instance.invalidateUser(u.id);
          await _loadPosts();
          if (!mounted) return;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Publicado: ${post.title}')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredSorted();
    final grouped = _group(list);
    final orderedKeys = list
        .map((p) => _humanDate(
              DateTime(p.createdAt.year, p.createdAt.month, p.createdAt.day),
            ))
        .toList();
    final seen = <String>{};
    final keys = <String>[];
    for (final k in orderedKeys) {
      if (seen.add(k)) keys.add(k);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Comunidad', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.onSurface, size: 28),
            tooltip: 'Nueva publicación',
            onPressed: _openCreatePost,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[400], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar publicaciones...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Recientes'),
                  selected: _sort == PostSort.recent,
                  onSelected: (s) {
                    if (s) setState(() => _sort = PostSort.recent);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Populares'),
                  selected: _sort == PostSort.popular,
                  onSelected: (s) {
                    if (s) setState(() => _sort = PostSort.popular);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount:
                  keys.fold<int>(0, (acc, k) => acc + 1 + grouped[k]!.length) +
                      (_suggestions.isNotEmpty ? 1 : 0),
              itemBuilder: (context, globalIndex) {
                int index = globalIndex;
                if (_suggestions.isNotEmpty) {
                  if (index == 0) {
                    return _buildSuggestionsSection();
                  }
                  index -= 1; // shift for suggestions header block
                }
                int cursor = 0;
                for (final k in keys) {
                  if (index == cursor) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 6),
                      child: Text(
                        k,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                      ),
                    );
                  }
                  cursor++;
                  final postsOfDay = grouped[k]!;
                  if (index < cursor + postsOfDay.length) {
                    final post = postsOfDay[index - cursor];
                    final user = AuthService.instance.currentUser;
                    final liked =
                        user != null && (_likesCache[post.id] ?? false);
                    return FadeInSlide(
                      duration: AppDurations.normal,
                      delay: Duration(milliseconds: 50 * (index - cursor)),
                      child: _PostCard(
                        post: post,
                        liked: liked,
                        likeTap: () => _likePost(post),
                        score: _suggestionScores[post.id],
                      ),
                    );
                  }
                  cursor += postsOfDay.length;
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Sugeridos para ti',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _suggestions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final mr = _suggestions[i];
              final p = mr.post;
              return ScaleFadeIn(
                duration: AppDurations.normal,
                delay: Duration(milliseconds: 80 * i),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.postDetail,
                    arguments: p,
                  ),
                  child: Container(
                    width: 240,
                    child: PremiumCard(
                      padding: const EdgeInsets.all(16),
                      borderRadius: 16,
                      gradientColors: [
                        Colors.white,
                        AppColors.primaryContainer.withOpacity(0.1),
                      ],
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              p.type.name,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Spacer(),
                          Text('${mr.score} pts',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          p.content,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[700], height: 1.3),
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (p.tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: -6,
                          children: p.tags.take(3).map((t) {
                            return Chip(
                              label:
                                  Text(t, style: const TextStyle(fontSize: 10)),
                              backgroundColor: AppColors.secondaryContainer,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                    ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

enum PostSort { recent, popular }

class _PostCard extends StatelessWidget {
  final Post post;
  final bool liked;
  final VoidCallback likeTap;
  final int? score;
  const _PostCard({
    required this.post,
    required this.liked,
    required this.likeTap,
    this.score,
  });

  String _humanDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final base = DateTime(date.year, date.month, date.day);
    if (base == today) return 'Hoy';
    if (base == yesterday) return 'Ayer';
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.postDetail,
        arguments: post,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      AppColors.secondaryContainer.withValues(alpha: .6),
                  child: Text(
                    post.title[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorId,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _humanDate(DateTime(post.createdAt.year,
                            post.createdAt.month, post.createdAt.day)),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (score != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('$score pts',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ),
                Icon(Icons.more_vert, color: Colors.grey[400], size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              post.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              post.content,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[700], height: 1.5),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: likeTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: liked
                          ? AppColors.primary.withValues(alpha: .15)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? AppColors.primary : Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          post.likes.toString(),
                          style: TextStyle(
                            color: liked ? AppColors.primary : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          color: Colors.grey, size: 18),
                      SizedBox(width: 6),
                      Text('0',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.share_outlined,
                      color: Colors.grey, size: 18),
                ),
              ],
            ),
          ],
      ),
    );
  }
}
