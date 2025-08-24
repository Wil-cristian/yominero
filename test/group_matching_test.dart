import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/core/matching/match_engine.dart';
import 'package:yominero/shared/models/group.dart';
import 'package:yominero/shared/models/user.dart';

void main() {
  group('Group matching', () {
    test('suggests groups with overlapping tags', () {
      const user = User(
        id: 'u1',
        username: 'u1',
        email: 'u1@test',
        name: 'U1',
        interests: const ['geologia', 'datos'],
        watchKeywords: const ['exploracion'],
        servicesOffered: const [],
      );
      final groups = [
        Group(
          id: 'g1',
          name: 'Geo',
          description: 'x',
          createdAt: DateTime.now(),
          ownerId: 'o',
          tags: {'geologia'},
        ),
        Group(
          id: 'g2',
          name: 'Mec',
          description: 'x',
          createdAt: DateTime.now(),
          ownerId: 'o',
          tags: {'mantenimiento'},
        ),
      ];
      final suggestions =
          MatchEngine.groupSuggestionsForUser(user, groups, threshold: 10);
      expect(suggestions.map((g) => g.id), contains('g1'));
      expect(suggestions.map((g) => g.id), isNot(contains('g2')));
    });
  });
}
