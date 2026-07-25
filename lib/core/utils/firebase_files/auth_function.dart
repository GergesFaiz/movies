import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';

import '../../model/user.dart';

class FirebaseFunctions {
  static Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        avatar: avatar,
        name: name,
        email: email,
        phoneNum: phone,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection(UserModel.collectionName)
          .doc(newUser.id)
          .set(newUser.toFirestore());

      return null;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') return 'The password is too weak.';
      if (e.code == 'email-already-in-use') {
        return 'The email is already in use.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> resetPassword(String email) async {
    try {
      await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();
    return doc.exists ? doc.data() : null;
  }
}
