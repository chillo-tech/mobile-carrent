import 'dart:convert';

PostResponse postResponseFromJson(String str) =>
    PostResponse.fromJson(json.decode(str));

String postResponseToJson(PostResponse data) => json.encode(data.toJson());

class PostResponse {
  String id;
  String make;
  String model;
  String year;
  String condition;
  String typeCarburant;
  String? description;
  int numberOfPlaces;
  String imagePathCar;
  String imagePathDocument;
  String phoneNumberProprietor;

  PostResponse({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.condition,
    required this.typeCarburant,
    required this.description,
    required this.numberOfPlaces,
    required this.imagePathCar,
    required this.imagePathDocument,
    required this.phoneNumberProprietor,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      condition: json['condition'],
      typeCarburant: json['typeCarburant'],
      description: json['description'],
      numberOfPlaces: json['numberOfPlaces'],
      imagePathCar: json['imagePathCar'],
      imagePathDocument: json['imagePathDocument'],
      phoneNumberProprietor: json['phoneNumberProprietor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'condition': condition,
      'typeCarburant': typeCarburant,
      'description': description,
      'numberOfPlaces': numberOfPlaces,
      'imagePathCar': imagePathCar,
      'imagePathDocument': imagePathDocument,
      'phoneNumberProprietor': phoneNumberProprietor,
    };
  }
}
