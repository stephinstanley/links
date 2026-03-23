/// Event class for Links BLoC
/// All user interactions and events are defined here
abstract class LinksEvent {
  const LinksEvent();
}

/// Event to fetch all links when app starts
class LinksFetched extends LinksEvent {
  const LinksFetched();
}

/// Event to add a new link
class LinkAdded extends LinksEvent {
  final String title;
  final String url;
  final String tag;

  const LinkAdded({required this.title, required this.url, required this.tag});
}

/// Event to update an existing link
class LinkUpdated extends LinksEvent {
  final String linkId;
  final String title;
  final String url;
  final String tag;

  const LinkUpdated({
    required this.linkId,
    required this.title,
    required this.url,
    required this.tag,
  });
}

/// Event to delete a link
class LinkDeleted extends LinksEvent {
  final String linkId;

  const LinkDeleted(this.linkId);
}

/// Event to search links by tag
class LinksSearchedByTag extends LinksEvent {
  final String tag;

  const LinksSearchedByTag(this.tag);
}

/// Event to search links by title
class LinksSearchedByTitle extends LinksEvent {
  final String query;

  const LinksSearchedByTitle(this.query);
}

/// Event to refresh the links list
class LinksRefreshed extends LinksEvent {
  const LinksRefreshed();
}
