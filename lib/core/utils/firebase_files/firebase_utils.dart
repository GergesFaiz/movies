import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/user.dart';

class FirebaseUtils {
  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) =>
              UserModel.fromFirestore(snapshot.data()!),
          toFirestore: (model, _) => model.toFirestore(),
        );
  }

  static Future<void> addUser(UserModel user) {
    return getUserCollection().doc(user.id).set(user);
  }
}
