/// Event class for EditLink BLoC
/// All user interactions for editing links are defined here
abstract class EditLinkEvent {
  const EditLinkEvent();
}

/// Event to edit an existing link
class EditLinkRequested extends EditLinkEvent {
  final String linkId;
  final String title;
  final String url;
  final String tag;

  const EditLinkRequested({
    required this.linkId,
    required this.title,
    required this.url,
    required this.tag,
  });
}
