import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/shared/models/post.dart';
import 'package:yominero/shared/models/user.dart';
import 'package:yominero/core/matching/match_engine.dart';

void main() {
  group('MatchEngine.computeScore', () {
    test('higher score with overlapping tags and recency', () {
      final recent = Post(
        id: 'a',
        type: PostType.community,
        authorId: 'u1',
        title: 'Post A',
        content: 'Contenido',
        createdAt: DateTime.now(),
        tags: const ['taladro', 'mantenimiento'],
        categories: const ['Maquinaria'],
      );
      final score = MatchEngine.computeScore(
        post: recent,
        refTags: {'taladro'},
        refCategories: {'Maquinaria'},
      );
      expect(score, greaterThanOrEqualTo(20));
    });
  });

  group('Match lists', () {
    const user = User(
      id: 'u1',
      username: 'user1',
      name: 'User 1',
      email: 'u1@test',
      servicesOffered: const [
        ServiceOffering(
          name: 'Mantenimiento',
          category: 'Maquinaria',
          tags: ['taladro', 'mantenimiento'],
          pricing: PricingRange(from: 10, to: 20, unit: 'USD'),
        ),
      ],
      interests: const ['drone'],
      watchKeywords: const ['mapeo'],
    );

    final posts = [
      Post(
        id: 'r1',
        type: PostType.request,
        authorId: 'other',
        title: 'Requiero mantenimiento de taladro',
        content: 'Detalles',
        createdAt: DateTime.now(),
        tags: const ['taladro'],
        categories: const ['Maquinaria'],
      ),
      Post(
        id: 'o1',
        type: PostType.offer,
        authorId: 'other',
        title: 'Servicio de mapeo con drone',
        content: 'Detalles',
        createdAt: DateTime.now(),
        tags: const ['mapeo', 'drone'],
        categories: const ['Topografía'],
      )
    ];

    test('requestsForUser returns request match', () {
      final r = MatchEngine.requestsForUser(user, posts);
      expect(r.length, 1);
      expect(r.first.post.id, 'r1');
    });

    test('opportunitiesForUser returns offer match', () {
      final r = MatchEngine.opportunitiesForUser(user, posts);
      expect(r.length, 1);
      expect(r.first.post.id, 'o1');
    });
  });
}
