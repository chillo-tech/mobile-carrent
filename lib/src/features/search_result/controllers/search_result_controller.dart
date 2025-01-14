import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/error_controller.dart';
import '../../../../models/car_filter.dart';
import '../../../../models/car_response.dart';
import '../../../../services/search.dart';

class SearchResultController extends GetxController {
  RxBool isPriceFilterApplied = false.obs;
  RxBool isCarTypeFilterApplied = false.obs;
  RxBool isCarBrandFilterApplied = false.obs;
  RxBool isYearFilterApplied = false.obs;
  CarFilter carFilter = CarFilter();
  RxList<CarResponse> filteredCars = RxList();

  final ErrorController errorController = ErrorController();

  Rx<List<String>> appliedFilters = Rx<List<String>>([]);
  RxList<Map<String, dynamic>> carBrands = RxList<Map<String, dynamic>>([
    // {'name': 'Toutes marques', 'isSelected': true},
    // {'name': 'Toyota Corolla', 'isSelected': false},
    // {'name': 'Honda Civic', 'isSelected': false},
    // {'name': 'Ford Mustang', 'isSelected': false},
    // {'name': 'Chevrolet Silverado', 'isSelected': false},
    // {'name': 'Volkswagen Golf', 'isSelected': false},
    // {'name': 'BMW 3 Series', 'isSelected': false},
  ]);

  RxList<Map<String, dynamic>> carTypes = RxList<Map<String, dynamic>>([
    // {'type': 'Tous types', 'isSelected': true},
    // {'type': 'Voitures de ville', 'isSelected': false},
    // {'type': 'Voitures compact', 'isSelected': false},
    // {'type': 'Grandes voitures', 'isSelected': false},
    // {'type': 'Voitures de luxe', 'isSelected': false},
    // {'type': 'SUVs', 'isSelected': false},
  ]);

  int? getMinPrice(List<CarResponse> cars) {
    if (cars.isEmpty) return 0;
    final prices = cars
        .map((car) => (int.tryParse(
            double.tryParse(car.price ?? '0')?.toStringAsFixed(0) ?? "0")))
        .toList();
    final minPrice = prices.reduce((a, b) => a! < b! ? a : b);

    return minPrice;
  }

  int? getMaxPrice(List<CarResponse> cars) {
    if (cars.isEmpty) return 0;
    final prices = cars
        .map((car) => (int.tryParse(
            double.tryParse(car.price ?? '0')?.toStringAsFixed(0) ?? "0")))
        .toList();
    final maxPrice = prices.reduce((a, b) => a! > b! ? a : b);

    return maxPrice;
  }

  int? getMinYear(List<CarResponse> cars) {
    if (cars.isEmpty) return 0;
    final years = cars
        .map((car) => (int.tryParse(
            double.tryParse(car.year ?? '0')?.toStringAsFixed(0) ?? "0")))
        .toList();
    final minYear = years.reduce((a, b) => a! < b! ? a : b);

    return minYear;
  }

  int? getMaxYear(List<CarResponse> cars) {
    if (cars.isEmpty) return 0;
    final prices = cars
        .map((car) => (int.tryParse(
            double.tryParse(car.year ?? '0')?.toStringAsFixed(0) ?? "0")))
        .toList();
    final maxYear = prices.reduce((a, b) => a! > b! ? a : b);

    return maxYear;
  }

  searchCar({bool navigate = false}) async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    SearchService searchService = SearchService();

    try {
      // Check if login details are correct by authenticating
      // const searchPayload = ;
      await searchService.searchCar(carFilter.toJson()).then((response) async {
        // myCars.value = response;
        print("---------------------");
        print(response);
        filteredCars.value = response;

        Get.back();
        print(filteredCars.toJson());
        if (navigate) {
          Get.toNamed('/search_result',
              arguments: {'activateSearchPlace': true});
        }
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }
}
