import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/links_repository.dart';
import 'delete_tag_event.dart';
import 'delete_tag_state.dart';

/// Business Logic Component (BLoC) for Deleting Tags
class DeleteTagBloc extends Bloc<DeleteTagEvent, DeleteTagState> {
  final LinksRepository repository;

  DeleteTagBloc(this.repository) : super(const DeleteTagInitial()) {
    on<DeleteTagRequested>(_onDeleteTagRequested);
  }

  /// Handle delete tag request event
  Future<void> _onDeleteTagRequested(
    DeleteTagRequested event,
    Emitter<DeleteTagState> emit,
  ) async {
    try {
      emit(const DeleteTagLoading());

      // Call repository to delete tag
      await repository.deleteTag(tagId: event.tagId);

      emit(const DeleteTagSuccess('Tag deleted successfully!'));
    } catch (e) {
      emit(DeleteTagError('Failed to delete tag: ${e.toString()}'));
    }
  }
}
