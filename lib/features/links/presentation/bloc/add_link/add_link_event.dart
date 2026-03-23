/// Event class for AddLink BLoC
/// All user interactions for adding links are defined here
abstract class AddLinkEvent {
  const AddLinkEvent();
}

/// Event to add a new link
class AddLinkRequested extends AddLinkEvent {
  final String title;
  final String url;
  final String tag;

  const AddLinkRequested({
    required this.title,
    required this.url,
    required this.tag,
  });
}
