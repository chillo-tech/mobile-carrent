class CarFilter {
  List<String>? makes;
  List<String>? typesCarburant;
  String? startDisponibilityDate;
  String? endDisponibilityDate;
  double? priceMin;
  double? priceMax;
  int? yearMin;
  int? yearMax;

  CarFilter({
    this.makes,
    this.typesCarburant,
    this.startDisponibilityDate,
    this.endDisponibilityDate,
    this.priceMin,
    this.priceMax,
    this.yearMin,
    this.yearMax,
  });

  // Méthode pour convertir un Map en instance de CarFilter
  // factory CarFilter.fromJson(Map<String, dynamic> map) {
  //   return CarFilter(
  //     make: map['make'] as String?,
  //     typeCarburant: map['typeCarburants'] as String?,
  //     startDisponibilityDate: map['startDisponibilityDate'],
  //     endDisponibilityDate: map['endDisponibilityDate'],
  //     priceMin:
  //         map['priceMin'] != null ? (map['priceMin'] as num).toDouble() : null,
  //     priceMax:
  //         map['priceMax'] != null ? (map['priceMax'] as num).toDouble() : null,
  //     yearMin: map['yearMin'] as int?,
  //     yearMax: map['yearMax'] as int?,
  //   );
  // }

  // Méthode pour convertir une instance de CarFilter en Map
  Map<String, dynamic> toJson() {
    return {
      'makes': makes?.join(','),
      'typesCarburant': typesCarburant?.join(','),
      'startDisponibilityDate': startDisponibilityDate,
      'endDisponibilityDate': endDisponibilityDate,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'yearMin': yearMin,
      'yearMax': yearMax,
    };
  }
}
