import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  AuthBloc(this.repository) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.signIn(event.email, event.password);
        emit(AuthAuthenticated(user!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.register(event.email, event.password);
        emit(AuthAuthenticated(user!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<AuthLogoutRequested>((event, emit) async {
      await repository.signOut();
      emit(AuthInitial());
    });
  }
}
