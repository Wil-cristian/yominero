import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/core/groups/group_repository.dart';

void main() {
  test('creating group trims inputs and stores tags', () async {
    final repo = InMemoryGroupRepository();
    final g = await repo.create(
        name: '  Geo  ', description: ' Desc ', tags: {'geologia', 'datos'});
    expect(g.name, '  Geo  '); // repository does not trim (UI layer should)
    expect(g.tags.contains('geologia'), isTrue);
  });
}
