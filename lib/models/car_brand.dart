import 'dart:convert';

List<CarBrand> carBrandFromJson(String str) =>
    List<CarBrand>.from(json.decode(str).map((x) => CarBrand.fromJson(x)));

String carBrandToJson(List<CarBrand> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarBrand {
  final String brand;
  final List<String> models;

  CarBrand({
    required this.brand,
    required this.models,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) => CarBrand(
        brand: json["brand"],
        models: List<String>.from(json["models"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
        "models": List<dynamic>.from(models.map((x) => x)),
      };
}
