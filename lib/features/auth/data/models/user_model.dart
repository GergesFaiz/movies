import '../../domain/entities/user_entity.dart';

/// Firestore representation of a user profile (`Users/{uid}`).
///
/// The password is intentionally not part of this model: Firebase Auth owns
/// credentials, so they must never be written to Firestore.
class UserModel {
  static const String collectionName = 'Users';

  final String id;
  final String avatar;
  final String name;
  final String email;
  final String phoneNum;

  const UserModel({
    required this.id,
    required this.avatar,
    required this.name,
    required this.email,
    required this.phoneNum,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
      'email': email,
      'phoneNum': phoneNum,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] as String? ?? '',
      avatar: data['avatar'] as String? ?? '',
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phoneNum: data['phoneNum'] as String? ?? '',
    );
  }

  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    phone: phoneNum,
    avatar: avatar,
  );
}
