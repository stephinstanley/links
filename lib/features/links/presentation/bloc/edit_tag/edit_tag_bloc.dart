import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/links_repository.dart';
import 'edit_tag_event.dart';
import 'edit_tag_state.dart';

/// Business Logic Component (BLoC) for Editing Tags
class EditTagBloc extends Bloc<EditTagEvent, EditTagState> {
  final LinksRepository repository;

  EditTagBloc(this.repository) : super(const EditTagInitial()) {
    on<EditTagRequested>(_onEditTagRequested);
  }

  /// Handle edit tag request event
  Future<void> _onEditTagRequested(
    EditTagRequested event,
    Emitter<EditTagState> emit,
  ) async {
    try {
      emit(const EditTagLoading());

      // Call repository to edit tag
      await repository.editTag(
        tagId: event.tagId,
        newTagName: event.newTagName,
      );

      emit(const EditTagSuccess('Tag updated successfully!'));
    } catch (e) {
      emit(EditTagError('Failed to update tag: ${e.toString()}'));
    }
  }
}
