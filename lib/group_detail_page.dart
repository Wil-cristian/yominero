import 'package:flutter/material.dart';
import 'package:yominero/core/di/locator.dart';
import 'package:yominero/core/groups/group_repository.dart';
import 'package:yominero/shared/models/group.dart';
import 'core/auth/auth_service.dart';

class GroupDetailPage extends StatefulWidget {
  final Group group;
  const GroupDetailPage({super.key, required this.group});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  late Group _group;
  final repo = sl<GroupRepository>();

  @override
  void initState() {
    super.initState();
    _group = widget.group;
  }

  bool get _isMember {
    final uid = AuthService.instance.currentUser?.id;
    if (uid == null) return false;
    return _group.memberIds.contains(uid);
  }

  Future<void> _toggleMembership() async {
    final uid = AuthService.instance.currentUser?.id;
    if (uid == null) return;
    if (_isMember) {
      await repo.leave(_group.id, uid);
      setState(() {
        _group = _group.copyWith(memberIds: {..._group.memberIds}..remove(uid));
      });
    } else {
      await repo.join(_group.id, uid);
      setState(() {
        _group = _group.copyWith(memberIds: {..._group.memberIds, uid});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_group.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleMembership,
        icon: Icon(_isMember ? Icons.logout : Icons.group_add),
        label: Text(_isMember ? 'Salir' : 'Unirme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_group.description,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _group.tags.map((t) => Chip(label: Text(t))).toList(),
            ),
            const SizedBox(height: 20),
            Row(children: [
              const Icon(Icons.people_alt_outlined, size: 18),
              const SizedBox(width: 6),
              Text('${_group.memberIds.length} miembros'),
            ]),
            const SizedBox(height: 30),
            const Text('Actividad (placeholder)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (_, i) => ListTile(
                  leading: const Icon(Icons.chat_bubble_outline),
                  title: Text('Publicación simulada #${i + 1}'),
                  subtitle: const Text('Integrar con posts filtrados por tag'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
