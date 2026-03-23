/// Base state class for AddLink BLoC
/// All state changes for add link flow
abstract class AddLinkState {
  const AddLinkState();
}

/// Initial state - form ready for input
class AddLinkInitial extends AddLinkState {
  const AddLinkInitial();
}

/// Loading state - adding link to Firebase
class AddLinkLoading extends AddLinkState {
  const AddLinkLoading();
}

/// Success state - link added successfully
class AddLinkSuccess extends AddLinkState {
  final String message;

  const AddLinkSuccess(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddLinkSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// Error state - something went wrong while adding
class AddLinkError extends AddLinkState {
  final String message;

  const AddLinkError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddLinkError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
