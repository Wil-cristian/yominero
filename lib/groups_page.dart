import 'package:flutter/material.dart';
import 'core/theme/colors.dart';
import 'core/di/locator.dart';
import 'core/groups/group_repository.dart';
import 'shared/models/group.dart';
import 'group_detail_page.dart';
import 'core/auth/auth_service.dart';
import 'core/matching/match_engine.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final _repo = sl<GroupRepository>();
  String _query = '';
  List<Group> _groups = [];
  List<Group> _suggested = [];
  final Map<String, int> _suggestionScores = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _repo.getAll();
    if (!mounted) return;
    // Compute suggestions in same frame to avoid extra setState + async context warning.
    _groups = data;
    _computeSuggestions();
    if (mounted) setState(() {});
  }

  List<Group> get _filtered => _groups
      .where((g) =>
          _query.isEmpty || g.name.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  void _openCreateGroup() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final tagsCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
              Text('Nuevo grupo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tagsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tags (separadas por coma)',
                  hintText: 'geologia, exploracion, datos',
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    final desc = descCtrl.text.trim();
                    final tags = tagsCtrl.text
                        .split(',')
                        .map((e) => e.trim().toLowerCase())
                        .where((e) => e.isNotEmpty)
                        .toSet();
                    if (name.isEmpty || desc.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Completa todos los campos')),
                      );
                      return;
                    }
                    final g = await _repo.create(
                        name: name, description: desc, tags: tags);
                    if (mounted) {
                      setState(() => _groups.insert(0, g));
                      _computeSuggestions();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Grupo "$name" creado')),
                      );
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Crear grupo'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _computeSuggestions() {
    final user = AuthService.instance.currentUser;
    if (user == null) return;
    final suggestions = MatchEngine.groupSuggestionsForUser(user, _groups);
    _suggested = suggestions;
    _suggestionScores.clear();
    for (final g in suggestions) {
      _suggestionScores[g.id] =
          MatchEngine.computeGroupScore(group: g, user: user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groups = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _openCreateGroup,
            tooltip: 'Nuevo grupo',
          )
        ],
      ),
      body: Column(
        children: [
          if (_suggested.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  Text('Sugeridos para ti',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                ],
              ),
            ),
            SizedBox(
              height: 130,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _suggested.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, i) {
                  final g = _suggested[i];
                  final score = _suggestionScores[g.id] ?? 0;
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => GroupDetailPage(group: g)),
                    ),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.secondaryContainer
                                    .withValues(alpha: 0.6),
                                child: Text(g.name[0].toUpperCase(),
                                    style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$score',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(g.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            g.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
                        hintText: 'Buscar grupos...',
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final g = groups[index];
                final isSuggested = _suggestionScores.containsKey(g.id);
                final score = _suggestionScores[g.id];
                final isMember = AuthService.instance.currentUser != null &&
                    g.memberIds.contains(AuthService.instance.currentUser!.id);
                return InkWell(
                  onTap: () => Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                            builder: (_) => GroupDetailPage(group: g)),
                      )
                      .then((_) => _load()),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.secondaryContainer
                              .withValues(alpha: 0.6),
                          child: Text(g.name[0].toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(g.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                  if (isSuggested && score != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text('$score',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  if (isMember)
                                    Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text('Miembro',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(g.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey[700])),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: -6,
                                children: g.tags
                                    .take(5)
                                    .map((t) => Chip(
                                          label: Text(t,
                                              style: const TextStyle(
                                                  fontSize: 11)),
                                          backgroundColor: Colors.grey[100],
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.people_alt_outlined,
                                      size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text('${g.memberIds.length} miembros',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600])),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
