import '../../../../helpers/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/car_filter.dart';
import '../../home/controllers/home_controller.dart';
import '../../search_result/controllers/search_result_controller.dart';
import '../entities/search_entity.dart';

class SearchBarController extends GetxController {
  final RxBool isPlaceSearchActivated = false.obs;
  final RxString startAvailableDate = ''.obs;
  final RxString endAvailableDate = ''.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchPlace = TextEditingController();

  List<SearchEntity> searchSections() {
    final HomeController homeController = Get.find();
    final SearchResultController searchResultController =
        Get.put(SearchResultController());

    return [
      SearchEntity(
        title: 'Marques',
        sections: homeController.cars.map((car) {
          return Section(
              icon: Assets.building,
              title: car.make,
              action: () async {
                searchResultController.carFilter = CarFilter();
                searchResultController.appliedFilters.value.clear();
                searchResultController.carFilter.makes = [];
                searchResultController.carFilter.makes?.assign(car.make);
                searchResultController.appliedFilters.value.addIf(
                    !searchResultController.appliedFilters.value
                        .contains('brand'),
                    'brand');
                searchResultController.update();
                print(searchResultController.carFilter.makes);
                await searchResultController.searchCar(navigate: true);
              });
        }).toList(),
      ),
      SearchEntity(
        title: 'Types',
        sections: [
          Section(
              icon: Assets.car,
              title: 'Super',
              action: () async {
                searchResultController.carFilter = CarFilter();
                searchResultController.appliedFilters.value.clear();
                searchResultController.carFilter.typesCarburant = [];
                searchResultController.carFilter.typesCarburant
                    ?.assign('Super');
                searchResultController.appliedFilters.value.addIf(
                    !searchResultController.appliedFilters.value
                        .contains('type'),
                    'type');
                searchResultController.update();
                print(searchResultController.appliedFilters);

                await searchResultController.searchCar(navigate: true);
              }),
          Section(
              icon: Assets.car,
              title: 'Gazoil',
              action: () async {
                searchResultController.carFilter = CarFilter();
                searchResultController.appliedFilters.value.clear();
                searchResultController.carFilter.typesCarburant = [];
                searchResultController.carFilter.typesCarburant
                    ?.assign('Gazoil');
                searchResultController.appliedFilters.value.addIf(
                    !searchResultController.appliedFilters.value
                        .contains('type'),
                    'type');
                searchResultController.update();
                print(searchResultController.appliedFilters);

                await searchResultController.searchCar(navigate: true);
              }),
          Section(
              icon: Assets.car,
              title: 'Electrique',
              action: () async {
                searchResultController.carFilter = CarFilter();
                searchResultController.appliedFilters.value.clear();
                searchResultController.carFilter.typesCarburant = [];
                searchResultController.carFilter.typesCarburant
                    ?.assign('Electrique');
                searchResultController.appliedFilters.value.addIf(
                    !searchResultController.appliedFilters.value
                        .contains('type'),
                    'type');
                searchResultController.update();
                print(searchResultController.appliedFilters);

                await searchResultController.searchCar(navigate: true);
              }),
        ],
      ),
    ];
  }

  List<SearchEntity> searchASections(List<SearchEntity> allSections) {
    if (searchQuery.value.isEmpty) {
      return allSections;
    }

    return allSections
        .map((entity) {
          final filteredSections = entity.sections
              .where((section) => section.title
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
              .toList();

          return filteredSections.isNotEmpty
              ? SearchEntity(
                  title: entity.title,
                  sections: filteredSections,
                )
              : null;
        })
        .whereType<SearchEntity>()
        .toList();
  }
// }
  // List<SearchEntity> searchSections = [
  //   SearchEntity(
  //     title: 'Localisations',
  //     sections: [
  //       Section(
  //         icon: Assets.pin,
  //         title: 'Position Actuelle',
  //         description: 'Votre position actuelle',
  //       ),
  //       Section(
  //         icon: Assets.earth,
  //         title: "N'importe où",
  //         description: 'Voir toutes les voitures',
  //       ),
  //     ],
  //   ),
  //   SearchEntity(
  //     title: 'Villes',
  //     sections: [
  //       Section(
  //         icon: Assets.building,
  //         title: 'Londres',
  //       ),
  //       Section(
  //         icon: Assets.building,
  //         title: 'Manchester',
  //       ),
  //       Section(
  //         icon: Assets.building,
  //         title: 'Birmingham',
  //       ),
  //     ],
  //   ),
  //   SearchEntity(
  //     title: 'Types',
  //     sections: [
  //       Section(
  //         icon: Assets.car,
  //         title: 'Voitures de ville',
  //       ),
  //       Section(
  //         icon: Assets.car,
  //         title: 'Petites voitures',
  //       ),
  //       Section(
  //         icon: Assets.car,
  //         title: 'Voitures compactes',
  //       ),
  //       Section(
  //         icon: Assets.car,
  //         title: 'Grandes voitures',
  //       ),
  //       Section(
  //         icon: Assets.car,
  //         title: 'Voitures de luxe',
  //       ),
  //       Section(
  //         icon: Assets.car,
  //         title: 'SUV',
  //       ),
  //     ],
  //   ),
  // ];

  @override
  void onInit() {
    isPlaceSearchActivated.value =
        Get.arguments?['activateSearchPlace'] ?? false;
    super.onInit();
  }
}
