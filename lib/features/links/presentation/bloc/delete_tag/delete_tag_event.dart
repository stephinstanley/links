/// Event class for DeleteTag BLoC
abstract class DeleteTagEvent {
  const DeleteTagEvent();
}

/// Event to delete a tag
class DeleteTagRequested extends DeleteTagEvent {
  final String tagId;

  const DeleteTagRequested({required this.tagId});
}
