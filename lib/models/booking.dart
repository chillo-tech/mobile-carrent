import 'dart:convert';

import 'package:carrent/models/car_response.dart';

BookingResponse bookingResponseFromJson(String str) =>
    BookingResponse.fromJson(json.decode(str));

List<BookingResponse> bookingResponsefromJsonList(List<dynamic> jsonList) {
  return jsonList.map((json) => BookingResponse.fromJson(json)).toList();
}

class BookingResponse {
  final String? id;
  CarResponse? car;
  final String? userId;
  final String? createDate;
  final String? updateDate;
  final String? startDate;
  final String? endDate;
  // final String? phoneNumberReservation;
  final String? idPayment;
  final bool? confirm;
  final String? sessionId;
  final String? withdrawStatus;
  final String? reservationStatus;

  BookingResponse({
    this.id,
    this.car,
    this.userId,
    this.createDate,
    this.updateDate,
    this.startDate,
    this.endDate,
    //  this.phoneNumberReservation,
    this.idPayment,
    this.confirm,
    this.sessionId,
    this.withdrawStatus,
    this.reservationStatus,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: json['id'] as String,
      car: CarResponse.fromJson(json['car']),
      userId: json['userId'] as String,
      createDate: json['createDate'] as String,
      updateDate: json['updateDate'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      // phoneNumberReservation: json['phoneNumberReservation'] as String,
      idPayment: json['idPayment'] as String?,
      confirm: json['confirm'] as bool,
      sessionId: json['sessionId'] as String,
      withdrawStatus: json['withdrawStatus'].toString().trim(),
      reservationStatus: json['reservationStatus'].toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car': car?.toJson(),
      'userId': userId,
      'createDate': createDate,
      'updateDate': updateDate,
      'startDate': startDate,
      'endDate': endDate,
      // 'phoneNumberReservation': phoneNumberReservation,
      'idPayment': idPayment,
      'confirm': confirm,
      'sessionId': sessionId,
      'withdrawStatus': withdrawStatus,
      'reservationStatus': reservationStatus,
    };
  }
}

BookingPayload bookingPayloadFromJson(String str) =>
    BookingPayload.fromJson(json.decode(str));

List<BookingPayload> bookingPayloadfromJsonList(List<dynamic> jsonList) {
  return jsonList.map((json) => BookingPayload.fromJson(json)).toList();
}

class BookingPayload {
  final DateTime startDate;
  final DateTime endDate;
  final String phoneNumberReservation;
  final String idCar;

  BookingPayload({
    required this.startDate,
    required this.endDate,
    required this.phoneNumberReservation,
    required this.idCar,
  });

  // Méthode pour convertir un JSON en un objet Reservation
  factory BookingPayload.fromJson(Map<String, dynamic> json) {
    return BookingPayload(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      phoneNumberReservation: json['phoneNumberReservation'],
      idCar: json['idCar'],
    );
  }

  // Méthode pour convertir un objet Reservation en JSON
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'phoneNumberReservation': phoneNumberReservation,
      'idCar': idCar,
    };
  }
}
