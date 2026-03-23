import '../../../models/tag.dart';

/// Base state for Tags BLoC
abstract class TagsState {
  const TagsState();
}

/// Initial state
class TagsInitial extends TagsState {
  const TagsInitial();
}

/// Loading state
class TagsLoading extends TagsState {
  const TagsLoading();
}

/// Success state with list of tags
class TagsSuccess extends TagsState {
  final List<Tag> tags;

  const TagsSuccess(this.tags);
}

/// Empty state
class TagsEmpty extends TagsState {
  const TagsEmpty();
}

/// Error state
class TagsError extends TagsState {
  final String message;

  const TagsError(this.message);
}
