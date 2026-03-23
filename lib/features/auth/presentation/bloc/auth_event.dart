abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email, password;
  AuthLoginRequested(this.email, this.password);
}

class AuthRegisterRequested extends AuthEvent {
  final String email, password;
  AuthRegisterRequested(this.email, this.password);
}

class AuthLogoutRequested extends AuthEvent {}
