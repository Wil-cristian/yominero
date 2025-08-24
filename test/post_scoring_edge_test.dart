import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/core/matching/match_engine.dart';
import 'package:yominero/shared/models/post.dart';

void main() {
  group('Post scoring edge cases', () {
    Post base({List<String>? tags, List<String>? cats, DateTime? created}) =>
        Post(
          id: 'p',
          type: PostType.community,
          authorId: 'a',
          title: 't',
          content: 'c',
          createdAt: created ?? DateTime.now(),
          tags: tags ?? const [],
          categories: cats ?? const [],
        );

    test('No overlap yields low score (only recency)', () {
      final p = base(tags: ['x']);
      final s = MatchEngine.computeScore(
          post: p, refTags: {'zzz'}, refCategories: {'none'});
      expect(s <= 10, isTrue);
    });

    test('Tag overlap caps at 50', () {
      final p = base(tags: ['a', 'b', 'c', 'd', 'e', 'f']);
      final s = MatchEngine.computeScore(
          post: p,
          refTags: {'a', 'b', 'c', 'd', 'e', 'f', 'g'},
          refCategories: {});
      expect(s >= 50, isTrue);
    });

    test('Category hits add expected points', () {
      final p1 = base(cats: ['Cat1']);
      final s1 = MatchEngine.computeScore(
          post: p1, refTags: {}, refCategories: {'Cat1'});
      final p2 = base(cats: ['Cat1', 'Cat2']);
      final s2 = MatchEngine.computeScore(
          post: p2, refTags: {}, refCategories: {'Cat1', 'Cat2'});
      expect(s2, greaterThan(s1));
    });
  });
}
