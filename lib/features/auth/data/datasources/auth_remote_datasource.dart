import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/stream_extensions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String email, String password);

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  });

  Future<void> forgotPassword(String email);

  Future<void> logout();

  bool get isLoggedIn;

  /// Emits the signed-in user's profile, or `null` when nobody is signed in.
  Stream<UserModel?> watchCurrentUser();

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String avatar,
  });

  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._auth, this._firestore);

  DocumentReference<Map<String, dynamic>> _userDocument(String uid) {
    return _firestore.collection(UserModel.collectionName).doc(uid);
  }

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) throw const AuthFailure('Please log in first');
    return user;
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Login failed');
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    final UserCredential credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_registerErrorMessage(e));
    }

    final user = credential.user!;
    final profile = UserModel(
      id: user.uid,
      avatar: avatar,
      name: name,
      email: email,
      phoneNum: phone,
    );

    try {
      await _userDocument(user.uid).set(profile.toFirestore());
    } on FirebaseException catch (e) {
      // Don't leave an account behind without a profile document.
      await user.delete();
      throw ServerFailure(e.message ?? 'Registration failed');
    }
  }

  String _registerErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'The email is already in use.';
      default:
        return e.message ?? 'Registration failed';
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

  @override
  Stream<UserModel?> watchCurrentUser() {
    return _auth.authStateChanges().switchMap((user) {
      if (user == null) return Stream<UserModel?>.value(null);

      return _userDocument(user.uid).snapshots().map((snapshot) {
        final data = snapshot.data();
        if (data == null) {
          return UserModel(
            id: user.uid,
            avatar: '',
            name: user.displayName ?? '',
            email: user.email ?? '',
            phoneNum: '',
          );
        }
        return UserModel.fromFirestore(data);
      });
    });
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String avatar,
  }) async {
    final user = _requireUser();
    try {
      await _userDocument(user.uid).set({
        'avatar': avatar,
        if (name.isNotEmpty) 'name': name,
        if (phone.isNotEmpty) 'phoneNum': phone,
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to update profile');
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = _requireUser();
    try {
      await _userDocument(user.uid).delete();
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Failed to delete account');
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to delete account');
    }
  }
}
