import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String userName;
  final String email;
  final String password;
  final String imageUrl;
  final String uid;
  final String createdAt;

  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.imageUrl,
    required this.uid,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
      'uid': uid,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      imageUrl: map['imageUrl'] as String,
      uid: map['uid'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
