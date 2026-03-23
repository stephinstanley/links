/// Base state class for DeleteLink BLoC
/// All state changes for delete link flow
abstract class DeleteLinkState {
  const DeleteLinkState();
}

/// Initial state - ready for deletion
class DeleteLinkInitial extends DeleteLinkState {
  const DeleteLinkInitial();
}

/// Loading state - deleting link from Firebase
class DeleteLinkLoading extends DeleteLinkState {
  const DeleteLinkLoading();
}

/// Success state - link deleted successfully
class DeleteLinkSuccess extends DeleteLinkState {
  final String message;

  const DeleteLinkSuccess(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteLinkSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// Error state - something went wrong while deleting
class DeleteLinkError extends DeleteLinkState {
  final String message;

  const DeleteLinkError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteLinkError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
