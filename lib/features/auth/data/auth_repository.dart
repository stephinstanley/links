import 'auth_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuthProvider dataProvider;
  AuthRepository(this.dataProvider);

  Future<User?> signIn(String email, String password) =>
      dataProvider.signIn(email, password);

  Future<User?> register(String email, String password) =>
      dataProvider.register(email, password);

  Future<void> signOut() => dataProvider.signOut();
  Future<void> sendPasswordResetEmail(String email) =>
      dataProvider.sendPasswordResetEmail(email);
  Stream<User?> get user => dataProvider.user;
}
