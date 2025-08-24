import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/core/groups/group_repository.dart';

void main() {
  group('InMemoryGroupRepository join/leave', () {
    final repo = InMemoryGroupRepository();

    test('create adds group and user as member', () async {
      final before = (await repo.getAll()).length;
      final g = await repo.create(name: 'Nuevo', description: 'Desc');
      final after = (await repo.getAll()).length;
      expect(after, before + 1);
      expect(g.memberIds.contains('current'), isTrue);
    });

    test('join adds user id', () async {
      final g = await repo.create(name: 'Joinable', description: '');
      await repo.join(g.id, 'uX');
      final fetched = await repo.getById(g.id);
      expect(fetched!.memberIds.contains('uX'), isTrue);
    });

    test('leave removes user id', () async {
      final g = await repo.create(name: 'Leaveable', description: '');
      await repo.join(g.id, 'uY');
      await repo.leave(g.id, 'uY');
      final fetched = await repo.getById(g.id);
      expect(fetched!.memberIds.contains('uY'), isFalse);
    });
  });
}
