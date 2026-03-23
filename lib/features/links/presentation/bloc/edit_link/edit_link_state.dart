/// Base state class for EditLink BLoC
/// All state changes for edit link flow
abstract class EditLinkState {
  const EditLinkState();
}

/// Initial state - form ready for input
class EditLinkInitial extends EditLinkState {
  const EditLinkInitial();
}

/// Loading state - updating link in Firebase
class EditLinkLoading extends EditLinkState {
  const EditLinkLoading();
}

/// Success state - link updated successfully
class EditLinkSuccess extends EditLinkState {
  final String message;

  const EditLinkSuccess(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditLinkSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// Error state - something went wrong while editing
class EditLinkError extends EditLinkState {
  final String message;

  const EditLinkError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditLinkError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
