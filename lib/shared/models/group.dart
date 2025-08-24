class Group {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final String ownerId;
  final Set<String> memberIds;
  final Set<String> tags; // for matching & discovery

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.ownerId,
    Set<String>? memberIds,
    Set<String>? tags,
  })  : memberIds = memberIds ?? <String>{},
        tags = tags ?? <String>{};

  Group copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    String? ownerId,
    Set<String>? memberIds,
    Set<String>? tags,
  }) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        ownerId: ownerId ?? this.ownerId,
        memberIds: memberIds ?? this.memberIds,
        tags: tags ?? this.tags,
      );

  bool get isEmpty => id.isEmpty;
}
