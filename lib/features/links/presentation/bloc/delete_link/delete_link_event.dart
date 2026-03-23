/// Event class for DeleteLink BLoC
/// All user interactions for deleting links are defined here
abstract class DeleteLinkEvent {
  const DeleteLinkEvent();
}

/// Event to delete an existing link
class DeleteLinkRequested extends DeleteLinkEvent {
  final String linkId;

  const DeleteLinkRequested({required this.linkId});
}
