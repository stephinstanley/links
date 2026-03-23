import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/links_repository.dart';
import 'edit_link_event.dart';
import 'edit_link_state.dart';

/// Business Logic Component (BLoC) for Editing Links
/// Handles the updating of existing links in Firebase
class EditLinkBloc extends Bloc<EditLinkEvent, EditLinkState> {
  final LinksRepository repository;

  EditLinkBloc(this.repository) : super(const EditLinkInitial()) {
    on<EditLinkRequested>(_onEditLinkRequested);
  }

  /// Handle edit link request event
  Future<void> _onEditLinkRequested(
    EditLinkRequested event,
    Emitter<EditLinkState> emit,
  ) async {
    try {
      emit(const EditLinkLoading());

      // Call repository to update link
      await repository.updateLink(
        linkId: event.linkId,
        title: event.title,
        url: event.url,
        tag: event.tag,
      );

      emit(const EditLinkSuccess('Link updated successfully!'));
    } catch (e) {
      emit(EditLinkError('Failed to update link: ${e.toString()}'));
    }
  }
}
