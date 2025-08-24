import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/core/matching/suggestion_cache.dart';
import 'package:yominero/core/matching/match_engine.dart';
import 'package:yominero/shared/models/post.dart';

void main() {
  group('SuggestionCache', () {
    test('cache hit returns same list instance and avoids recompute', () {
      final cache = SuggestionCache.instance;
      cache.clear();
      int buildCount = 0;
      final posts = [
        Post(
          id: 'p1',
          type: PostType.community,
          authorId: 'u',
          title: 'A',
          content: 'Texto',
          createdAt: DateTime.now(),
          tags: const ['x'],
        ),
      ];
      final signature = buildPostSignature(posts);
      final first = cache.getOrCompute(
        userId: 'u1',
        signature: signature,
        builder: () {
          buildCount++;
          return [MatchResult(posts.first, 42)];
        },
      );
      final second = cache.getOrCompute(
        userId: 'u1',
        signature: signature,
        builder: () {
          buildCount++;
          return [MatchResult(posts.first, 55)];
        },
      );
      expect(buildCount, 1, reason: 'Second call should reuse cache');
      expect(identical(first, second), isTrue);
      expect(second.single.score, 42);
    });

    test('invalidateUser forces recompute', () {
      final cache = SuggestionCache.instance;
      cache.clear();
      int buildCount = 0;
      final posts = [
        Post(
          id: 'p1',
          type: PostType.community,
          authorId: 'u',
          title: 'A',
          content: 'Texto',
          createdAt: DateTime.now(),
          tags: const ['x'],
        ),
      ];
      final signature = buildPostSignature(posts);
      cache.getOrCompute(
        userId: 'u1',
        signature: signature,
        builder: () {
          buildCount++;
          return [MatchResult(posts.first, 10)];
        },
      );
      SuggestionCache.instance.invalidateUser('u1');
      final afterInvalidate = cache.getOrCompute(
        userId: 'u1',
        signature: signature,
        builder: () {
          buildCount++;
          return [MatchResult(posts.first, 99)];
        },
      );
      expect(buildCount, 2, reason: 'Should rebuild after invalidation');
      expect(afterInvalidate.single.score, 99);
    });

    test('signature change triggers recompute without manual invalidation', () {
      final cache = SuggestionCache.instance;
      cache.clear();
      int buildCount = 0;
      final basePost = Post(
        id: 'p1',
        type: PostType.community,
        authorId: 'u',
        title: 'A',
        content: 'Texto',
        createdAt: DateTime.now(),
        tags: const ['x'],
      );
      final posts1 = [basePost];
      final sig1 = buildPostSignature(posts1);
      cache.getOrCompute(
        userId: 'u1',
        signature: sig1,
        builder: () {
          buildCount++;
          return [MatchResult(basePost, 5)];
        },
      );
      // Simulate likes change -> new signature
      final updated = basePost.copyWith(likes: 10);
      final posts2 = [updated];
      final sig2 = buildPostSignature(posts2);
      expect(sig2 == sig1, isFalse,
          reason: 'Signature must differ after likes change');
      final result2 = cache.getOrCompute(
        userId: 'u1',
        signature: sig2,
        builder: () {
          buildCount++;
          return [MatchResult(updated, 15)];
        },
      );
      expect(buildCount, 2,
          reason: 'Second build expected due to signature change');
      expect(result2.single.score, 15);
    });
  });
}
