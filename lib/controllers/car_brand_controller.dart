import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/car_brand.dart';

class CarBrandController extends GetxController {
  RxList<CarBrand> carBrands = <CarBrand>[].obs;
  RxList<CarBrand> filteredBrands = <CarBrand>[].obs;

  RxList<String> carModels = <String>[].obs;
  RxList<String> filteredModels = <String>[].obs;
  RxList<String> carCondition =
      <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'].obs;
  RxList<String> carTypeCarbutant = <String>[
    'Essence',
    'Gazoil',
    'Electrique',
    'Hybride',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadCarBrands();
  }

  /// Charge le fichier JSON et le convertit en objets CarBrand
  Future<void> loadCarBrands() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/car_brands.json');
      List<CarBrand> brands = carBrandFromJson(jsonString);
      carBrands.assignAll(brands);
      filteredBrands.assignAll(brands);
    } catch (e) {
      print("Erreur lors du chargement des marques : $e");
    }
  }

  void loadCarModelsFromACar(String carBrand) {
    carModels.assignAll(carBrands
        .where((car) {
          return car.brand == carBrand;
        })
        .first
        .models);
  }

  /// Filtrer les marques selon un mot-clé
  void filterBrands(String query) {
    if (query.isEmpty) {
      filteredBrands.assignAll(carBrands);
    } else {
      filteredBrands.assignAll(
        carBrands.where(
            (brand) => brand.brand.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }
}
