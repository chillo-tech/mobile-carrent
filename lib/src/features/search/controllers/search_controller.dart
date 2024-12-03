import '../../../../helpers/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entities/search_entity.dart';

class SearchBarController extends GetxController {
  final RxBool isPlaceSearchActivated = false.obs;
  final RxString startAvailableDate = ''.obs;
  final RxString endAvailableDate = ''.obs;
  final TextEditingController searchPlace =
      TextEditingController();

  List<SearchEntity> searchSections = [
    SearchEntity(
      title: 'Localisations',
      sections: [
        Section(
          icon: Assets.pin,
          title: 'Position Actuelle',
          description: 'Votre position actuelle',
        ),
        Section(
          icon: Assets.earth,
          title: "N'importe où",
          description: 'Voir toutes les voitures',
        ),
      ],
    ),
    SearchEntity(
      title: 'Villes',
      sections: [
        Section(
          icon: Assets.building,
          title: 'Londres',
        ),
        Section(
          icon: Assets.building,
          title: 'Manchester',
        ),
        Section(
          icon: Assets.building,
          title: 'Birmingham',
        ),
      ],
    ),
    SearchEntity(
      title: 'Types',
      sections: [
        Section(
          icon: Assets.car,
          title: 'Voitures de ville',
        ),
        Section(
          icon: Assets.car,
          title: 'Petites voitures',
        ),
        Section(
          icon: Assets.car,
          title: 'Voitures compactes',
        ),
        Section(
          icon: Assets.car,
          title: 'Grandes voitures',
        ),
        Section(
          icon: Assets.car,
          title: 'Voitures de luxe',
        ),
        Section(
          icon: Assets.car,
          title: 'SUV',
        ),
      ],
    ),
  ];

  @override
  void onInit() {
    isPlaceSearchActivated.value =
        Get.arguments?['activateSearchPlace'] ?? false;
    super.onInit();
  }
}
