import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/features/posts/data/in_memory_post_repository.dart';

void main() {
  test('liking a post increments once per user', () {
    final repo = InMemoryPostRepository();
    final first = repo.getAll().first;
    final initialLikes = first.likes;
    final applied1 = repo.like(first.id, 'user1');
    expect(applied1, isTrue);
    final afterFirst = repo.getAll().firstWhere((p) => p.id == first.id);
    expect(afterFirst.likes, initialLikes + 1);
    final applied2 = repo.like(first.id, 'user1');
    expect(applied2, isFalse); // second like ignored
    final afterSecond = repo.getAll().firstWhere((p) => p.id == first.id);
    expect(afterSecond.likes, initialLikes + 1); // unchanged
  });
}
