class UserResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? password;
  final String phoneNumber;

  UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.password,
    required this.phoneNumber,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String?,
      password: json['password'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}
