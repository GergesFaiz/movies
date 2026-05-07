class User {
  static const String collectionName='Users';
   String id;
  int avatar;
 final String name;
final  String email;
  String password;
 final String phoneNum;
 User({
  this.id='',
  required this.avatar,
 required this.name,
 required this.email,
  required this.phoneNum,
  required this.password});
  Map<String,dynamic>toFirestore(){
    return
    
    {
      'id':id,
      'avatar':avatar,
      'name':name,
      'email':email,
      'phonenumber':phoneNum,
      "password":password
    }

    ;
  }
  User.fromFirestore(Map<String,dynamic>data):this(
    avatar:data["avatar"] as int,
    name: data['name'] ,
    email: data['email'],
    password:data["password"] ,
    phoneNum:data['phonenumber'] ,
    id: data['id']);
}
