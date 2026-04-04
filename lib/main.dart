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
  Object? startupError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    setupServiceLocator();
  } catch (error) {
    startupError = error;
  }
  runApp(MyApp(startupError: startupError));
}

class MyApp extends StatelessWidget {
  final Object? startupError;

  const MyApp({super.key, this.startupError});

  @override
  Widget build(BuildContext context) {
    if (startupError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 56,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'App startup failed',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text('$startupError', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    const Text(
                      'For web/desktop, configure Firebase options using FlutterFire CLI.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

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
