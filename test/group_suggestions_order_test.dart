import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/core/matching/match_engine.dart';
import 'package:yominero/shared/models/group.dart';
import 'package:yominero/shared/models/user.dart';

void main() {
  test('Group suggestions sorted by score desc', () {
    const user = User(
        id: 'u',
        username: 'u',
        email: 'u@test',
        name: 'U',
        interests: const ['x'],
        watchKeywords: const [],
        servicesOffered: const []);
    final newer = DateTime.now();
    final older = DateTime.now().subtract(const Duration(days: 40));
    final g1 = Group(
      id: 'g1',
      name: 'A',
      description: '',
      createdAt: newer,
      ownerId: 'o',
      tags: {'x'},
      memberIds: {'o'},
    );
    final g2 = Group(
      id: 'g2',
      name: 'B',
      description: '',
      createdAt: older,
      ownerId: 'o',
      tags: {'x'},
      memberIds: {
        'o',
        'm1',
        'm2',
        'm3',
        'm4',
        'm5',
        'm6',
        'm7',
        'm8',
        'm9',
        'm10',
        'm11',
        'm12'
      },
    );
    final list = MatchEngine.groupSuggestionsForUser(user, [g1, g2],
        threshold: 0, limit: 10);
    // g2 has popularity, g1 has recency -> either could win; ensure not empty and contains both
    expect(list.length, 2);
    // ensure order corresponds to descending computed scores
    final s1 = MatchEngine.computeGroupScore(group: g1, user: user);
    final s2 = MatchEngine.computeGroupScore(group: g2, user: user);
    if (s1 > s2) {
      expect(list.first.id, 'g1');
    } else if (s2 > s1) {
      expect(list.first.id, 'g2');
    }
  });
}
