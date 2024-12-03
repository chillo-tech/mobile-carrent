import 'dart:convert';

import 'package:carrent/models/car_response.dart';

BookingResponse bookingResponseFromJson(String str) =>
    BookingResponse.fromJson(json.decode(str));

List<BookingResponse> bookingResponsefromJsonList(List<dynamic> jsonList) {
  return jsonList.map((json) => BookingResponse.fromJson(json)).toList();
}

class BookingResponse {
  String? id;
  String? rentalStartDate;
  String? rentalEndDate;
  CarResponse? car;

  BookingResponse({
    this.id,
    this.rentalStartDate,
    this.rentalEndDate,
    this.car,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: json['id'] as String,
      rentalStartDate: json['rentalStartDate'],
      rentalEndDate: json['rentalEndDate'],
      car: CarResponse.fromJson(json['car']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rentalStartDate': rentalStartDate,
      'rentalEndDate': rentalEndDate,
      'car': car?.toJson(),
    };
  }
}
