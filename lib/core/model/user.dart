class UserModel {
  static const String collectionName = "Users";
  String id;
  String avatar;
  String name;
  String email;
  String phoneNum;
  String password;

  UserModel({
    required this.id,
    required this.avatar,
    required this.name,
    required this.email,
    required this.phoneNum,
    required this.password,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "avatar": avatar,
      "name": name,
      "email": email,
      "phoneNum": phoneNum,
      "password": password,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      id: data["id"] ?? "",
      avatar: data["avatar"] ?? "",
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      phoneNum: data["phoneNum"] ?? "",
      password: data["password"] ?? "",
    );
  }
}
