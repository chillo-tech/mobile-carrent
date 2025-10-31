import 'dart:convert';

import 'package:carrent/common/common_fonctions.dart';

CarResponse carResponseFromJson(String str) =>
    CarResponse.fromJson(json.decode(str));

List<CarResponse> carResponsefromJsonList(List<dynamic> jsonList) {
  return jsonList.map((json) => CarResponse.fromJson(json)).toList();
}

class CarResponse {
  final String id;
  final String make;
  final String model;
  final String immatriculation;
  final String? city;
  final String? year;
  final String? condition;
  final String? typeCarburant;
  final String? description;
  final String? status;
  final int numberOfPlaces;
  final List<dynamic>? imagePathCar;
  final String? imagePathDocument;
  final String? phoneNumberProprietor;
  final String? price;
  final String? unformattedPrice;
  final String? startDisponibilityDate;
  final String? endDisponibilityDate;
  final String? createdDate;
  final int? reviewNumber;
  final int? reservationNumber;
  final String? proprietorId;
  final String? proprietorName;

  CarResponse({
    required this.id,
    required this.make,
    required this.model,
    required this.immatriculation,
    required this.city,
    required this.year,
    required this.condition,
    this.typeCarburant,
    required this.description,
    required this.status,
    required this.numberOfPlaces,
    this.imagePathCar,
    this.imagePathDocument,
    this.phoneNumberProprietor,
    this.price,
    this.unformattedPrice,
    this.startDisponibilityDate,
    this.endDisponibilityDate,
    this.createdDate,
    this.reviewNumber,
    this.reservationNumber,
    this.proprietorId,
    this.proprietorName,
  });

  // Factory method to create a Car instance from JSON
  factory CarResponse.fromJson(Map<String, dynamic> json) {
    return CarResponse(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      immatriculation: json['immatriculation'],
      city: json['city'] ?? '',
      year: json['year'],
      condition: (json['condition'] ?? 0.0).toString(),
      typeCarburant: json['typeCarburant'],
      description: json['description'],
      status: json['status'],
      numberOfPlaces: json['numberOfPlaces'] ?? 0, // Default to 0 if null
      imagePathCar: json['imagePathCar'] ??
          [
            'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg'
          ],
      imagePathDocument: json['imagePathDocument'] ??
          'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg',
      phoneNumberProprietor: json['phoneNumberProprietor'] ?? '',
      price: formatAmount(double.parse(json['price']?.toString() ?? '0')),
      unformattedPrice: (double.tryParse(json['price']?.toString() ?? '0')
              ?.toStringAsFixed(0) ??
          "0"),
      startDisponibilityDate: json['startDisponibilityDate'],
      endDisponibilityDate: json['endDisponibilityDate'],
      createdDate: json['createdDate'],
      reviewNumber: json['reviewNumber'] ?? 0,
      reservationNumber: json['reservationNumber'] ?? 0,
      proprietorId: json['proprietorId'],
      proprietorName: json['proprietorName'],
    );
  }

  // Method to convert Car instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'immatriculation': immatriculation,
      'city': city,
      'year': year,
      'condition': (condition != null) ? condition : 5,
      'typeCarburant': typeCarburant,
      'description': description,
      'status': status,
      'numberOfPlaces': numberOfPlaces,
      'imagePathCar': imagePathCar,
      'imagePathDocument': imagePathDocument,
      'phoneNumberProprietor': phoneNumberProprietor,
      'price': (price != null) ? double.parse(unformattedPrice!) : 0.0,
      'startDisponibilityDate': startDisponibilityDate,
      'endDisponibilityDate': endDisponibilityDate,
      'createdDate': createdDate,
      'reviewNumber': reviewNumber,
      'reservationNumber': reservationNumber,
    };
  }
}

Review reviewResponseFromJson(String str) => Review.fromJson(json.decode(str));

List<Review> reviewResponsefromJsonList(List<dynamic> jsonList) {
  return jsonList.map((json) => Review.fromJson(json)).toList();
}

class Review {
  final String? id;
  final String? vehicleId;
  final String? image;
  final String? name;
  final int? rating;
  final String? location;
  final String review;
  final String? createdDate;
  final String? userName;

  Review({
    this.id,
    this.vehicleId,
    this.image,
    this.name,
    this.rating,
    this.location,
    required this.review,
    this.createdDate,
    this.userName,
  });

  /// Convertir un objet Review en un Map<String, dynamic> (JSON)
  Map<String, dynamic> toJson() {
    return {
      // 'image': image,
      // 'name': name,
      'rating': rating,
      // 'location': location,
      'message': review,
    };
  }

  /// Créer un objet Review à partir d'un Map<String, dynamic> (JSON)
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      vehicleId: json['vehicleId'],
      rating: json['rating'],
      // location: json['location'],
      review: json['message'],
      createdDate: json['createdDate'],
      userName: json['userName'],
    );
  }
}
