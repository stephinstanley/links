import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/links_repository.dart';
import 'links_event.dart';
import 'links_state.dart';

/// Business Logic Component (BLoC) for Links
/// SIMPLIFIED: Only handles fetching links
class LinksBloc extends Bloc<LinksEvent, LinksState> {
  final LinksRepository repository;

  LinksBloc(this.repository) : super(const LinksInitial()) {
    on<LinksFetched>(_onLinksFetched);
  }

  /// Handle fetch links event
  Future<void> _onLinksFetched(
    LinksFetched event,
    Emitter<LinksState> emit,
  ) async {
    try {
      emit(const LinksLoading());

      await emit.forEach(
        repository.getUserLinks(),
        onData: (links) {
          if (links.isEmpty) {
            return const LinksEmpty();
          }
          return LinksSuccess(links);
        },
        onError: (error, stackTrace) {
          return LinksError(error.toString());
        },
      );
    } catch (e) {
      emit(LinksError('Failed to fetch links: ${e.toString()}'));
    }
  }
}
