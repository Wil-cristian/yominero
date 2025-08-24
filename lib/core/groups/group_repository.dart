import 'package:yominero/shared/models/group.dart';

abstract class GroupRepository {
  Stream<List<Group>> watchAll();
  Future<List<Group>> getAll();
  Future<Group> create(
      {required String name, required String description, Set<String>? tags});
  Future<void> join(String groupId, String userId);
  Future<void> leave(String groupId, String userId);
  Future<Group?> getById(String id);
}

class InMemoryGroupRepository implements GroupRepository {
  final List<Group> _groups = [
    Group(
      id: 'g1',
      name: 'Seguridad en Mina',
      description: 'Buenas prácticas y protocolos.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ownerId: 'seed',
      memberIds: {'seed'},
      tags: {'seguridad', 'protocolos', 'ppe'},
    ),
    Group(
      id: 'g2',
      name: 'Geología & Exploración',
      description: 'Intercambio de datos geológicos.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ownerId: 'seed',
      memberIds: {'seed'},
      tags: {'geologia', 'exploracion', 'datos'},
    ),
    Group(
      id: 'g3',
      name: 'Mantenimiento Equipos',
      description: 'Soporte y tips de mantenimiento.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ownerId: 'seed',
      memberIds: {'seed'},
      tags: {'mantenimiento', 'equipos'},
    ),
  ];
  InMemoryGroupRepository();

  @override
  Stream<List<Group>> watchAll() async* {
    yield _groups.toList();
  }

  @override
  Future<List<Group>> getAll() async => _groups.toList();

  @override
  Future<Group> create(
      {required String name,
      required String description,
      Set<String>? tags}) async {
    final g = Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      createdAt: DateTime.now(),
      ownerId: 'current',
      memberIds: {'current'},
      tags: tags ?? {},
    );
    _groups.insert(0, g);
    return g;
  }

  @override
  Future<void> join(String groupId, String userId) async {
    final idx = _groups.indexWhere((g) => g.id == groupId);
    if (idx == -1) return;
    final g = _groups[idx];
    if (!g.memberIds.contains(userId)) {
      _groups[idx] = g.copyWith(memberIds: {...g.memberIds, userId});
    }
  }

  @override
  Future<void> leave(String groupId, String userId) async {
    final idx = _groups.indexWhere((g) => g.id == groupId);
    if (idx == -1) return;
    final g = _groups[idx];
    if (g.memberIds.contains(userId)) {
      final newMembers = {...g.memberIds}..remove(userId);
      _groups[idx] = g.copyWith(memberIds: newMembers);
    }
  }

  @override
  Future<Group?> getById(String id) async =>
      _groups.firstWhere((g) => g.id == id,
          orElse: () => Group(
              id: '',
              name: '',
              description: '',
              createdAt: DateTime.fromMillisecondsSinceEpoch(0),
              ownerId: ''));
}
