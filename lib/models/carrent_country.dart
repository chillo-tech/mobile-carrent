// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class CountryAvailable {
  String? status;
  String? message;
  List<CarrentCountry>? countries;

  CountryAvailable({this.status, this.message, this.countries});

  CountryAvailable.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['country'] != null) {
      countries = <CarrentCountry>[];
      json['country'].forEach((v) {
        countries!.add(CarrentCountry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (countries != null) {
      data['country'] = countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(covariant CountryAvailable other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.message == message &&
        listEquals(other.countries, countries);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ countries.hashCode;
}

class CarrentCountry {
  int? id;
  String? shortName;
  String? longName;
  String? iso2;
  String? iso3;
  String? flag;
  int? numcode;
  int? phonecode;
  int length = 9;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;

  CarrentCountry(
      {this.id,
      this.shortName,
      this.longName,
      this.iso2,
      this.iso3,
      this.flag,
      this.numcode,
      this.phonecode,
      this.createdBy,
      this.createdDate,
      this.lastModifiedBy,
      this.lastModifiedDate});

  CarrentCountry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortName = json['shortName'];
    longName = json['longName'];
    iso2 = json['iso2'];
    iso3 = json['iso3'];
    flag = json['flag'];
    numcode = json['numcode'];
    phonecode = json['phonecode'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedDate = json['lastModifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shortName'] = shortName;
    data['longName'] = longName;
    data['iso2'] = iso2;
    data['iso3'] = iso3;
    data['flag'] = flag;
    data['numcode'] = numcode;
    data['phonecode'] = phonecode;
    data['createdBy'] = createdBy;
    data['createdDate'] = createdDate;
    data['lastModifiedBy'] = lastModifiedBy;
    data['lastModifiedDate'] = lastModifiedDate;
    return data;
  }
}
