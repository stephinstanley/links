/// Base event for Tags BLoC
abstract class TagsEvent {
  const TagsEvent();
}

/// Event to fetch all user tags
class TagsFetched extends TagsEvent {
  const TagsFetched();
}

/// Event to add a new tag
class TagAdded extends TagsEvent {
  final String tagName;

  const TagAdded(this.tagName);
}

/// Event to refresh tags
class TagsRefreshed extends TagsEvent {
  const TagsRefreshed();
}
