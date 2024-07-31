import 'dart:convert';

class AppException implements Exception {
  final response;

  AppException([this.response]);

  String toString() {
    return json.encode(response);
  }
}

class FetchDataException extends AppException {
  FetchDataException([dynamic errorResponse]) : super(errorResponse);
}

class BadRequestException extends AppException {
  BadRequestException([errorResponse]) : super(errorResponse);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([errorResponse]) : super(errorResponse);
}

class InvalidInputException extends AppException {
  InvalidInputException([String? errorResponse]) : super(errorResponse);
}

class NotFoundException extends AppException {
  NotFoundException([String? errorResponse]) : super(errorResponse);
}
