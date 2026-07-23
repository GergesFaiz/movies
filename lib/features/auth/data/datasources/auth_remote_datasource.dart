import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String email, String password);

  Future<void> register(String email, String password);

  Future<void> forgotPassword(String email);

  Future<void> logout();

  bool get isLoggedIn;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Login failed');
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Registration failed');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Failed to send reset email');
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  bool get isLoggedIn => _auth.currentUser != null;
}
