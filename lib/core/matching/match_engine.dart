import 'package:yominero/shared/models/post.dart';
import 'package:yominero/shared/models/user.dart';
import 'package:yominero/shared/models/group.dart';

class MatchResult {
  final Post post;
  final int score;
  const MatchResult(this.post, this.score);
}

class MatchEngine {
  static int computeScore({
    required Post post,
    required Set<String> refTags,
    required Set<String> refCategories,
  }) {
    int score = 0;

    // Tags (0-50)
    final overlap = post.tags.toSet().intersection(refTags).length;
    score += (overlap * 10).clamp(0, 50);

    // Categories (0-20)
    final catHits = post.categories.toSet().intersection(refCategories).length;
    if (catHits >= 2) {
      score += 20;
    } else if (catHits == 1) {
      score += 10;
    }

    // Recency (0-10)
    final hours = DateTime.now().difference(post.createdAt).inHours;
    if (hours <= 48) {
      score += 10;
    } else if (hours <= 24 * 7) {
      score += 6;
    } else if (hours <= 24 * 30) {
      score += 3;
    }

    // (Placeholder) author reputation (0-5) omitted — needs user lookup.
    return score.clamp(0, 100);
  }

  /// Suggestions for provider: focus on ServiceRequest + community posts relevant.
  static List<MatchResult> requestsForUser(User user, List<Post> posts,
      {int threshold = 35}) {
    final tagPool = user.servicesOffered.expand((s) => s.tags).toSet();
    final catPool = user.servicesOffered.map((s) => s.category).toSet();
    // Boost pools with followed tags/categories
    tagPool.addAll(user.followedTags);
    catPool.addAll(user.followedCategories);
    final results = <MatchResult>[];
    for (final p in posts) {
      if (!user.preferredPostTypes.contains(p.type)) continue;
      if (p.type == PostType.request || p.type == PostType.community) {
        final score = computeScore(
          post: p,
          refTags: tagPool,
          refCategories: catPool,
        );
        if (score >= threshold) results.add(MatchResult(p, score));
      }
    }
    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }

  /// Opportunities (user seeking offers / posts by interests & watchKeywords)
  static List<MatchResult> opportunitiesForUser(User user, List<Post> posts,
      {int threshold = 20}) {
    final interestTags = {
      ...user.interests,
      ...user.watchKeywords,
      ...user.followedTags,
    }.toSet();
    final results = <MatchResult>[];
    for (final p in posts) {
      if (!user.preferredPostTypes.contains(p.type)) continue;
      if (p.type == PostType.offer || p.type == PostType.community) {
        final score = computeScore(
          post: p,
          refTags: interestTags,
          refCategories: const {},
        );
        if (score >= threshold) results.add(MatchResult(p, score));
      }
    }
    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }

  // ---- GROUP MATCHING ----
  // Score groups by overlap of tags with user interests/services + light popularity boost
  static int computeGroupScore({
    required Group group,
    required User user,
  }) {
    int score = 0;
    final userTagPool = <String>{
      ...user.interests,
      ...user.watchKeywords,
      ...user.servicesOffered.expand((s) => s.tags),
    };
    final overlap = group.tags.intersection(userTagPool).length;
    score += (overlap * 12).clamp(0, 60); // tag overlap weight
    // popularity (member count tiers)
    final m = group.memberIds.length;
    if (m >= 200) {
      score += 25;
    } else if (m >= 100) {
      score += 18;
    } else if (m >= 50) {
      score += 12;
    } else if (m >= 10) {
      score += 6;
    }
    // recency (newer groups get small boost)
    final days = DateTime.now().difference(group.createdAt).inDays;
    if (days <= 7) {
      score += 10;
    } else if (days <= 30) {
      score += 6;
    } else if (days <= 90) {
      score += 3;
    }
    return score.clamp(0, 100);
  }

  static List<Group> groupSuggestionsForUser(User user, List<Group> groups,
      {int threshold = 30, int limit = 6}) {
    final scored = <_ScoredGroup>[];
    for (final g in groups) {
      if (g.memberIds.contains(user.id)) continue;
      final s = computeGroupScore(group: g, user: user);
      if (s >= threshold) scored.add(_ScoredGroup(g, s));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(limit).map((e) => e.group).toList();
  }
}

class _ScoredGroup {
  final Group group;
  final int score;
  _ScoredGroup(this.group, this.score);
}
