/// Event class for EditTag BLoC
abstract class EditTagEvent {
  const EditTagEvent();
}

/// Event to edit an existing tag
class EditTagRequested extends EditTagEvent {
  final String tagId;
  final String newTagName;

  const EditTagRequested({required this.tagId, required this.newTagName});
}
