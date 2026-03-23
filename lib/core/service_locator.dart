import 'package:get_it/get_it.dart';
import 'package:links/features/links/data/links_data_provider.dart';
import 'package:links/features/links/data/links_repository.dart';
import 'package:links/features/links/presentation/bloc/add_link/add_link_bloc.dart';
import 'package:links/features/links/presentation/bloc/add_tag/add_tag_bloc.dart';
import 'package:links/features/links/presentation/bloc/delete_link/delete_link_bloc.dart';
import 'package:links/features/links/presentation/bloc/delete_tag/delete_tag_bloc.dart';
import 'package:links/features/links/presentation/bloc/edit_link/edit_link_bloc.dart';
import 'package:links/features/links/presentation/bloc/edit_tag/edit_tag_bloc.dart';
import 'package:links/features/links/presentation/bloc/links/links_bloc.dart';
import 'package:links/features/links/presentation/bloc/tags/tags_bloc.dart';

final getIt = GetIt.instance;

/// Setup service locator for dependency injection
void setupServiceLocator() {
  // Reset GetIt if it's already been set up (useful for hot reload)
  if (getIt.isRegistered<LinksDataProvider>()) {
    getIt.reset();
  }

  // Data Layer
  getIt.registerSingleton<LinksDataProvider>(LinksDataProvider());

  getIt.registerSingleton<LinksRepository>(
    LinksRepository(getIt<LinksDataProvider>()),
  );

  // BLoCs - Register as lazy singletons so they're created on first access
  getIt.registerLazySingleton<TagsBloc>(
    () => TagsBloc(getIt<LinksRepository>()),
  );

  getIt.registerLazySingleton<LinksBloc>(
    () => LinksBloc(getIt<LinksRepository>()),
  );

  getIt.registerLazySingleton<AddLinkBloc>(
    () => AddLinkBloc(getIt<LinksRepository>()),
  );

  getIt.registerLazySingleton<EditLinkBloc>(
    () => EditLinkBloc(getIt<LinksRepository>()),
  );

  getIt.registerLazySingleton<DeleteLinkBloc>(
    () => DeleteLinkBloc(getIt<LinksRepository>()),
  );

  getIt.registerLazySingleton<AddTagBloc>(
    () => AddTagBloc(getIt<LinksRepository>()),
  );

  getIt.registerLazySingleton<EditTagBloc>(
    () => EditTagBloc(getIt<LinksRepository>()),
  );

  getIt.registerLazySingleton<DeleteTagBloc>(
    () => DeleteTagBloc(getIt<LinksRepository>()),
  );
}
