/// Tag Model - Represents a tag entity
class Tag {
  final String id;
  final String tagName;
  final String userId;

  Tag({required this.id, required this.tagName, required this.userId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          tagName == other.tagName &&
          userId == other.userId;

  @override
  int get hashCode => id.hashCode ^ tagName.hashCode ^ userId.hashCode;

  @override
  String toString() => 'Tag(id: $id, tagName: $tagName, userId: $userId)';
}
