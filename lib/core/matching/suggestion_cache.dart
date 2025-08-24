import 'match_engine.dart';
import 'package:yominero/shared/models/post.dart';

/// Simple in-memory cache for post match suggestions keyed by user + post list signature.
class SuggestionCacheEntry {
  final List<MatchResult> suggestions;
  final String signature; // hash/signature of inputs
  SuggestionCacheEntry(this.suggestions, this.signature);
}

class SuggestionCache {
  static final SuggestionCache instance = SuggestionCache._();
  SuggestionCache._();

  final Map<String, SuggestionCacheEntry> _cache = {};

  /// Get suggestions for [userId] using [signature] of current posts.
  /// If cache hit with same signature return cached, else compute via [builder] and store.
  List<MatchResult> getOrCompute({
    required String userId,
    required String signature,
    required List<MatchResult> Function() builder,
  }) {
    final existing = _cache[userId];
    if (existing != null && existing.signature == signature) {
      return existing.suggestions;
    }
    final fresh = builder();
    _cache[userId] = SuggestionCacheEntry(fresh, signature);
    return fresh;
  }

  void invalidateUser(String userId) => _cache.remove(userId);
  void clear() => _cache.clear();
}

/// Utility to build a stable signature for a list of posts relevant to matching.
String buildPostSignature(List<Post> posts) {
  // Include id, likes, createdAt (ms) & type to reflect meaningful match-impacting changes.
  return posts
      .map((p) =>
          '${p.id}:${p.type.index}:${p.likes}:${p.createdAt.millisecondsSinceEpoch}')
      .join('|');
}
