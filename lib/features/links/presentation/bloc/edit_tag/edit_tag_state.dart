/// Base state class for EditTag BLoC
abstract class EditTagState {
  const EditTagState();
}

/// Initial state
class EditTagInitial extends EditTagState {
  const EditTagInitial();
}

/// Loading state
class EditTagLoading extends EditTagState {
  const EditTagLoading();
}

/// Success state
class EditTagSuccess extends EditTagState {
  final String message;

  const EditTagSuccess(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditTagSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// Error state
class EditTagError extends EditTagState {
  final String message;

  const EditTagError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditTagError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
