import 'dart:convert';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

class UserResponse {
  final String id;
  final String completeName;
  final String? email;
  final String? password;
  final String phoneNumber;

  UserResponse({
    required this.id,
    required this.completeName,
    this.email,
    this.password,
    required this.phoneNumber,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String,
      completeName: json['completeName'] as String,
      email: json['email'] as String?,
      password: json['password'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completeName': completeName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}
