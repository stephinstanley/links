import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/links_repository.dart';
import 'tags_event.dart';
import 'tags_state.dart';

/// Business Logic Component (BLoC) for Tags
/// SIMPLIFIED: Only handles fetching tags
class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final LinksRepository repository;
  StreamSubscription? _tagsStreamSubscription;

  TagsBloc(this.repository) : super(const TagsInitial()) {
    on<TagsFetched>(_onTagsFetched);
  }

  /// Handle fetch tags event
  Future<void> _onTagsFetched(
    TagsFetched event,
    Emitter<TagsState> emit,
  ) async {
    try {
      print('🚀 TagsBloc: TagsFetched event triggered');
      emit(const TagsLoading());

      int eventCount = 0;
      await emit.forEach(
        repository.getUserTags(),
        onData: (tags) {
          eventCount++;
          print(
            '🎯 TagsBloc.onData [$eventCount]: Received ${tags.length} tags',
          );
          if (tags.isNotEmpty) {
            print('🎯 Tags = $tags');
          }
          if (tags.isEmpty) {
            return const TagsEmpty();
          } else {
            return TagsSuccess(tags);
          }
        },
        onError: (error, stackTrace) {
          print('❌ TagsBloc.onError: $error');
          return TagsError(error.toString());
        },
      );
      print('✅ TagsBloc: Tags loaded successfully');
    } catch (e) {
      print('❌ TagsBloc: Exception - $e');
      emit(TagsError('Failed to fetch tags: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _tagsStreamSubscription?.cancel();
    return super.close();
  }
}
