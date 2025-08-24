import 'package:flutter/material.dart';
import 'core/theme/colors.dart';
import 'core/auth/auth_service.dart';
import 'package:yominero/shared/models/post.dart';
import 'core/routing/app_router.dart';
import 'core/di/locator.dart';
import 'features/posts/domain/post_repository.dart';

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

  @override
  void initState() {
    super.initState();
    _repo = Locator.postRepository;
    _posts = _repo.getAll();
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

  void _likePost(Post post) {
    final idx = _posts.indexWhere((p) => p.id == post.id);
    if (idx == -1) return;
    final user = AuthService.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para dar like.')),
      );
      return;
    }
    final applied = _repo.like(post.id, user.id);
    if (!applied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya le diste like a este post.')),
      );
      return;
    }
    setState(() => _posts = _repo.getAll());
  }

  void _openCreatePost() {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicia sesión para publicar.')),
      );
      return;
    }
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Nueva publicación',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                ),
                minLines: 4,
                maxLines: 6,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        final content = contentCtrl.text.trim();
                        if (title.isEmpty || content.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Completa título y contenido.')),
                          );
                          return;
                        }
                        final newPost = _repo.create(
                          author: user.name,
                          title: title,
                          content: content,
                        );
                        setState(() {
                          _posts = _repo.getAll();
                          _query = '';
                          _sort = PostSort.recent;
                        });
                        Navigator.pop(ctx);
                        // Scroll to top after frame.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Publicado: ${newPost.title}'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Publicar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
                  keys.fold<int>(0, (acc, k) => acc + 1 + grouped[k]!.length),
              itemBuilder: (context, globalIndex) {
                int cursor = 0;
                for (final k in keys) {
                  if (globalIndex == cursor) {
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
                  if (globalIndex < cursor + postsOfDay.length) {
                    final post = postsOfDay[globalIndex - cursor];
                    final user = AuthService.instance.currentUser;
                    final liked =
                        user != null && _repo.hasUserLiked(post.id, user.id);
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.postDetail,
                        arguments: post,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.secondaryContainer
                                      .withValues(alpha: .6),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.author,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _humanDate(DateTime(
                                            post.createdAt.year,
                                            post.createdAt.month,
                                            post.createdAt.day)),
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.more_vert,
                                    color: Colors.grey[400], size: 20),
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
                                  ?.copyWith(
                                      color: Colors.grey[700], height: 1.5),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _likePost(post),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: liked
                                          ? AppColors.primary
                                              .withValues(alpha: .15)
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          liked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: liked
                                              ? AppColors.primary
                                              : Colors.grey[600],
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${post.likes}',
                                          style: TextStyle(
                                            color: liked
                                                ? AppColors.primary
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.chat_bubble_outline,
                                          color: Colors.grey, size: 18),
                                      SizedBox(width: 6),
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(Icons.share_outlined,
                                      color: Colors.grey[600], size: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}

enum PostSort { recent, popular }
