import 'dart:convert';

import '../models/carrent_country.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:unique_identifier/unique_identifier.dart';

import '../common/storage_constants.dart';
import '../helpers/country_helper.dart';
import 'error_controller.dart';

class CountriesController extends GetxController {
  var isFetchingCountry = false.obs;
  final countriesResponse = <CarrentCountry>[].obs;
  final filteredCountries = <CarrentCountry>[].obs;
  final selectedCountry = CarrentCountry().obs;

  final selectedRecommendedCountry = CarrentCountry().obs;

  final selectedRecoveryCountry = CarrentCountry().obs;

  ErrorController errorController = ErrorController();

  @override
  void onInit() {
    fetchSaraAvailableCountries();
    super.onInit();
  }

  // Future<void> initUniqueIdentifierState() async {
  //   String? identifier;
  //   try {
  //     identifier = await UniqueIdentifier.serial;
  //     debugPrint("Device ID: $identifier");
  //   } on PlatformException {
  //     identifier = 'Failed to get Unique Identifier';
  //   }
  // }

  void fetchSaraAvailableCountries() async {
    try {
      isFetchingCountry(true);

      final cachedCountriesCodePhoneList =
          GetStorage().read(StorageConstants.countriesCodePhoneList)
                  as List<dynamic>? ??
              [];

      if (cachedCountriesCodePhoneList.isEmpty ||
          cachedCountriesCodePhoneList.length <= 0) {
        // final countriesService = CountriesService();
        // final response = await countriesService.getSaraCountriesAvailable();
        final countries = await saraCountriesFromJson();
        GetStorage().write(StorageConstants.countriesCodePhoneList, countries);

        countriesResponse.assignAll(countries);
      } else {
        countriesResponse.clear();
        for (var saraCountry in cachedCountriesCodePhoneList) {
          if (saraCountry is Map) {
            countriesResponse
                .add(CarrentCountry.fromJson(saraCountry as Map<String, dynamic>));
          } else {
            countriesResponse.add(saraCountry);
          }
        }
      }

      final phoneCodeStored =
          GetStorage().read(StorageConstants.selectedPhoneCode);

      if (phoneCodeStored != null) {
        selectedCountry.value = countriesResponse
            .firstWhere((country) => country.phonecode == phoneCodeStored);
        selectedRecommendedCountry.value = countriesResponse
            .firstWhere((country) => country.phonecode == phoneCodeStored);

        selectedRecoveryCountry.value = countriesResponse
            .firstWhere((country) => country.phonecode == phoneCodeStored);
      } else {
        selectedCountry.value = countriesResponse.firstWhere(
            (country) => country.phonecode == CountryHelper.PHONE_CODE);
        selectedRecommendedCountry.value = countriesResponse.firstWhere(
            (country) => country.phonecode == CountryHelper.PHONE_CODE);
        selectedRecoveryCountry.value = countriesResponse.firstWhere(
            (country) => country.phonecode == CountryHelper.PHONE_CODE);
      }

      print("Selected Country: ${selectedCountry.value.toJson()}");
      isFetchingCountry(false);
    } catch (error) {
      isFetchingCountry(false);
      Get.back();
      errorController.handleError(error);
    }
  }

  void filterCountries(value) {
    var results = countriesResponse.where((country) {
      return (country.shortName?.toLowerCase().contains(value.toLowerCase()) ??
              false) ||
          country.phonecode
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase());
    }).toList();
    filteredCountries.assignAll(results);
  }

  Future<List<CarrentCountry>> saraCountriesFromJson() async {
    var str = await rootBundle.loadString('assets/data/new_countries.json');
    var decoded = json.decode(str);

    var list = (decoded as List)
        .map(
          (e) => CarrentCountry(
            id: e['id'],
            shortName: e['name'],
            longName: e['name'],
            iso2: e['iso2'],
            iso3: e['iso3'],
            flag: e['flag'],
            phonecode: int.parse(e['phoneCode']),
          ),
        )
        .toList();

    return list;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
