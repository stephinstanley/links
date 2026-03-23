import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/links_repository.dart';
import 'add_link_event.dart';
import 'add_link_state.dart';

/// Business Logic Component (BLoC) for Adding Links
/// Handles the creation of new links in Firebase
class AddLinkBloc extends Bloc<AddLinkEvent, AddLinkState> {
  final LinksRepository repository;

  AddLinkBloc(this.repository) : super(const AddLinkInitial()) {
    on<AddLinkRequested>(_onAddLinkRequested);
  }

  /// Handle add link request event
  Future<void> _onAddLinkRequested(
    AddLinkRequested event,
    Emitter<AddLinkState> emit,
  ) async {
    try {
      emit(const AddLinkLoading());

      // Call repository to add link
      await repository.addLink(
        title: event.title,
        url: event.url,
        tag: event.tag,
      );

      emit(const AddLinkSuccess('Link added successfully!'));
    } catch (e) {
      emit(AddLinkError('Failed to add link: ${e.toString()}'));
    }
  }
}
