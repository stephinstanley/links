/// Link Domain Model
/// Represents a link entity in the application
class Link {
  final String? id; // Firestore document ID
  final String title;
  final String url;
  final DateTime createdAt;
  final String tag;
  final DateTime? updatedAt;

  Link({
    this.id,
    required this.title,
    required this.url,
    required this.createdAt,
    this.tag = 'default',
    this.updatedAt,
  });

  /// Create a copy of the Link with modified fields
  Link copyWith({
    String? id,
    String? title,
    String? url,
    DateTime? createdAt,
    String? tag,
    DateTime? updatedAt,
  }) {
    return Link(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      tag: tag ?? this.tag,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Link &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          url == other.url &&
          tag == other.tag;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ url.hashCode ^ tag.hashCode;

  @override
  String toString() =>
      'Link(id: $id, title: $title, url: $url, tag: $tag, createdAt: $createdAt)';
}
