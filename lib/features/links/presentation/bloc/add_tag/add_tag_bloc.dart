import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/links_repository.dart';
import 'add_tag_event.dart';
import 'add_tag_state.dart';

/// Business Logic Component (BLoC) for Adding Tags
class AddTagBloc extends Bloc<AddTagEvent, AddTagState> {
  final LinksRepository repository;

  AddTagBloc(this.repository) : super(const AddTagInitial()) {
    on<AddTagRequested>(_onAddTagRequested);
  }

  /// Handle add tag request event
  Future<void> _onAddTagRequested(
    AddTagRequested event,
    Emitter<AddTagState> emit,
  ) async {
    try {
      emit(const AddTagLoading());

      // Call repository to add tag
      await repository.addTag(tagName: event.tagName);

      emit(const AddTagSuccess('Tag added successfully!'));
    } catch (e) {
      emit(AddTagError('Failed to add tag: ${e.toString()}'));
    }
  }
}
