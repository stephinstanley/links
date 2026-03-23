/// Event class for AddTag BLoC
abstract class AddTagEvent {
  const AddTagEvent();
}

/// Event to add a new tag
class AddTagRequested extends AddTagEvent {
  final String tagName;

  const AddTagRequested({required this.tagName});
}
