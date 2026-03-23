/// Base state class for AddTag BLoC
abstract class AddTagState {
  const AddTagState();
}

/// Initial state
class AddTagInitial extends AddTagState {
  const AddTagInitial();
}

/// Loading state
class AddTagLoading extends AddTagState {
  const AddTagLoading();
}

/// Success state
class AddTagSuccess extends AddTagState {
  final String message;

  const AddTagSuccess(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddTagSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// Error state
class AddTagError extends AddTagState {
  final String message;

  const AddTagError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddTagError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
