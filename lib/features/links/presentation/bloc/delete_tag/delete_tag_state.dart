/// Base state class for DeleteTag BLoC
abstract class DeleteTagState {
  const DeleteTagState();
}

/// Initial state
class DeleteTagInitial extends DeleteTagState {
  const DeleteTagInitial();
}

/// Loading state
class DeleteTagLoading extends DeleteTagState {
  const DeleteTagLoading();
}

/// Success state
class DeleteTagSuccess extends DeleteTagState {
  final String message;

  const DeleteTagSuccess(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteTagSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// Error state
class DeleteTagError extends DeleteTagState {
  final String message;

  const DeleteTagError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteTagError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
