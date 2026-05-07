import 'package:firebase_auth/firebase_auth.dart'as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/model/user.dart';
class FirebaseFunctions {
  
  static Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    try {
      
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      
      User newUser = User(
        id: userCredential.user!.uid, 
        avatar: avatar,
        name: name,
        email: email,
        phoneNum: phone,
        password: password, 
      );

      
      await FirebaseFirestore.instance
          .collection(User.collectionName)
          .doc(newUser.id)
          .set(newUser.toFirestore());

      return null; 
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') return 'The password is too weak.';
      if (e.code == 'email-already-in-use') return 'The email is already in use.';
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
}