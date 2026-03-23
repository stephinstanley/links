import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shared/config/theme.dart';
import 'features/links/presentation/screens/link_manager_page.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/service_locator.dart';
import 'features/links/presentation/bloc/links/links_bloc.dart';
import 'features/links/presentation/bloc/tags/tags_bloc.dart';
import 'features/links/presentation/bloc/add_link/add_link_bloc.dart';
import 'features/links/presentation/bloc/edit_link/edit_link_bloc.dart';
import 'features/links/presentation/bloc/delete_link/delete_link_bloc.dart';
import 'features/links/presentation/bloc/add_tag/add_tag_bloc.dart';
import 'features/links/presentation/bloc/edit_tag/edit_tag_bloc.dart';
import 'features/links/presentation/bloc/delete_tag/delete_tag_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Temporary: No Hive, just Firebase and in-memory for now
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TagsBloc>(create: (context) => getIt<TagsBloc>()),
        BlocProvider<LinksBloc>(create: (context) => getIt<LinksBloc>()),
        BlocProvider<AddLinkBloc>(create: (context) => getIt<AddLinkBloc>()),
        BlocProvider<EditLinkBloc>(create: (context) => getIt<EditLinkBloc>()),
        BlocProvider<DeleteLinkBloc>(
          create: (context) => getIt<DeleteLinkBloc>(),
        ),
        BlocProvider<AddTagBloc>(create: (context) => getIt<AddTagBloc>()),
        BlocProvider<EditTagBloc>(create: (context) => getIt<EditTagBloc>()),
        BlocProvider<DeleteTagBloc>(
          create: (context) => getIt<DeleteTagBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Links',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return LinkManagerPage();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
