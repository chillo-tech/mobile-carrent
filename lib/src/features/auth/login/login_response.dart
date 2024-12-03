// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.accessToken,
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.phoneNumber,
  });

  String? accessToken;
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? phoneNumber;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json["token"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "token": accessToken,
        "refresh_expires_in": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
      };
}
