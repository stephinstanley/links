import '../../../models/link.dart';

/// Base state class for Links BLoC
/// All state changes flow through here
abstract class LinksState {
  const LinksState();
}

/// Initial state - app just started
class LinksInitial extends LinksState {
  const LinksInitial();
}

/// Loading state - fetching or processing links
class LinksLoading extends LinksState {
  const LinksLoading();
}

/// Success state - successfully fetched/processed links
class LinksSuccess extends LinksState {
  final List<Link> links;

  const LinksSuccess(this.links);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinksSuccess &&
          runtimeType == other.runtimeType &&
          links == other.links;

  @override
  int get hashCode => links.hashCode;
}

/// Empty state - user has no links yet
class LinksEmpty extends LinksState {
  const LinksEmpty();
}

/// Error state - something went wrong
class LinksError extends LinksState {
  final String message;

  const LinksError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinksError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// Search results state
class LinksSearchResults extends LinksState {
  final List<Link> results;
  final String query;

  const LinksSearchResults(this.results, this.query);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinksSearchResults &&
          runtimeType == other.runtimeType &&
          results == other.results &&
          query == other.query;

  @override
  int get hashCode => results.hashCode ^ query.hashCode;
}
