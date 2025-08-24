import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/core/matching/match_engine.dart';
import 'package:yominero/shared/models/group.dart';
import 'package:yominero/shared/models/user.dart';

void main() {
  group('Group scoring edge cases', () {
    const user = User(
      id: 'u',
      username: 'u',
      email: 'u@test',
      name: 'User',
      interests: const ['a', 'b'],
      watchKeywords: const ['c'],
      servicesOffered: const [],
    );

    Group g({Set<String>? tags, int members = 0, int daysAgo = 1}) => Group(
          id: 'g$members',
          name: 'G',
          description: 'd',
          createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
          ownerId: 'o',
          memberIds: {
            'o',
            if (members > 0) ...List.generate(members, (i) => 'm$i')
          },
          tags: tags ?? {'z'},
        );

    test('Tag overlap influences score', () {
      final s1 =
          MatchEngine.computeGroupScore(group: g(tags: {'a'}), user: user);
      final s2 =
          MatchEngine.computeGroupScore(group: g(tags: {'a', 'b'}), user: user);
      expect(s2, greaterThanOrEqualTo(s1));
    });

    test('Popularity tiers add points', () {
      final low =
          MatchEngine.computeGroupScore(group: g(members: 5), user: user);
      final mid =
          MatchEngine.computeGroupScore(group: g(members: 60), user: user);
      final high =
          MatchEngine.computeGroupScore(group: g(members: 210), user: user);
      expect(mid, greaterThan(low));
      expect(high, greaterThan(mid));
    });
  });
}
