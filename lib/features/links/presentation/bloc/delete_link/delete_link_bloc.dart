import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/links_repository.dart';
import 'delete_link_event.dart';
import 'delete_link_state.dart';

/// Business Logic Component (BLoC) for Deleting Links
/// Handles the deletion of links in Firebase
class DeleteLinkBloc extends Bloc<DeleteLinkEvent, DeleteLinkState> {
  final LinksRepository repository;

  DeleteLinkBloc(this.repository) : super(const DeleteLinkInitial()) {
    on<DeleteLinkRequested>(_onDeleteLinkRequested);
  }

  /// Handle delete link request event
  Future<void> _onDeleteLinkRequested(
    DeleteLinkRequested event,
    Emitter<DeleteLinkState> emit,
  ) async {
    try {
      emit(const DeleteLinkLoading());

      // Call repository to delete link
      await repository.deleteLink(linkId: event.linkId);

      emit(const DeleteLinkSuccess('Link deleted successfully!'));
    } catch (e) {
      emit(DeleteLinkError('Failed to delete link: ${e.toString()}'));
    }
  }
}
