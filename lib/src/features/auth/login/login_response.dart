// // To parse this JSON data, do
// //
// //     final loginResponse = loginResponseFromJson(jsonString);

// import 'dart:convert';

// LoginResponse loginResponseFromJson(String str) =>
//     LoginResponse.fromJson(json.decode(str));

// String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

// class LoginResponse {
//   LoginResponse({
//     this.accessToken,
//     this.lastname,
//     this.email,
//     this.password,
//     this.phoneNumber,
//   });

//   String? accessToken;
//   String? lastname;
//   String? email;
//   String? password;
//   String? phoneNumber;

//   factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
//         accessToken: json["token"],
//         lastname: json["completeName"],
//         email: json["email"],
//         password: json["password"],
//         phoneNumber: json["phoneNumber"],
//       );

//   Map<String, dynamic> toJson() => {
//         "token": accessToken,
//         "lastname": lastname,
//         "email": email,
//         "password": password,
//         "phoneNumber": phoneNumber,
//       };
// }
