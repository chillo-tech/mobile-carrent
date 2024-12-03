import 'dart:convert';

List<AfricanCountry> africanCountryFromJson(String str) =>
    List<AfricanCountry>.from(
        json.decode(str).map((x) => AfricanCountry.fromJson(x)));

String africanCountryToJson(List<AfricanCountry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AfricanCountry {
  AfricanCountry({this.name, this.code, this.dialCode, this.length, this.flag});

  String? name;
  String? code;
  String? dialCode;
  int? length;
  String? flag;

  factory AfricanCountry.fromJson(Map<String, dynamic> json) => AfricanCountry(
      name: json["name"],
      code: json["code"],
      dialCode: json["dial_code"],
      length: json["length"],
      flag: json["flag"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "dial_code": dialCode,
        "length": length,
        "flag": flag,
      };
}
