import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/app_sizes.dart';
import '../../../../common/common_fonctions.dart';
import '../../../../helpers/assets.dart';
import '../../../../models/car_filter.dart';
import '../../../../theme/theme.dart';
import '../../home/controllers/home_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../../widgets/primary_button.dart';
import '../controllers/search_result_controller.dart';

class SearchResultScreen extends StatefulWidget {
  SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final HomeController homeController = Get.find();
  final SearchResultController searchResultController =
      Get.put(SearchResultController());
  final SearchBarController _searchBarController =
      Get.put(SearchBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Stack(
                  children: [
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _searchBarController
                                .isPlaceSearchActivated(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: ColorStyle.bgFieldGrey,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Icon(
                                      FontAwesomeIcons.arrowLeft,
                                      color: ColorStyle.textBlackColor,
                                      size: 20.0,
                                    ),
                                  ),
                                  // SvgPicture.asset(Assets.search),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    _searchBarController
                                            .searchPlace.value.text.isNotEmpty
                                        ? _searchBarController
                                            .searchPlace.value.text
                                        : "N’importe ou",
                                    style: GoogleFonts.lato(
                                      color: ColorStyle.greyColor,
                                      fontSize: 16.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          gapH10,
                          Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                      color: searchResultController
                                              .appliedFilters.value.isEmpty
                                          ? ColorStyle.containerBg
                                          : ColorStyle.blackBackground,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: searchResultController
                                          .appliedFilters.value.isEmpty
                                      ? SvgPicture.asset(Assets.filter)
                                      : InkWell(
                                          onTap: (() async {
                                            searchResultController
                                                .appliedFilters.value
                                                .clear();

                                            searchResultController.carFilter =
                                                CarFilter();
                                            await searchResultController
                                                .searchCar();

                                            setState(() {});
                                            searchResultController.update();
                                          }),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                Assets.filter,
                                                color: ColorStyle.lightWhite,
                                              ),
                                              Text(
                                                "(${searchResultController.appliedFilters.value.length})",
                                                style: GoogleFonts.lato(
                                                  color: ColorStyle.lightWhite,
                                                  fontSize: 12.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                ),
                                filterButton("prix",
                                    isFilterApplied: searchResultController
                                        .appliedFilters.value
                                        .contains('price'), action: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return priceFilter();
                                    },
                                  ).then((_) {
                                    setState(
                                        () {}); // Forcer la mise à jour de l'interface
                                  });
                                }),
                                filterButton("Type de vehicule",
                                    isFilterApplied: searchResultController
                                        .appliedFilters.value
                                        .contains('type'), action: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: typeFilter(),
                                      );
                                    },
                                  ).then((_) {
                                    setState(
                                        () {}); // Forcer la mise à jour de l'interface
                                  });
                                }),
                                filterButton("Marque",
                                    isFilterApplied: searchResultController
                                        .appliedFilters.value
                                        .contains('brand'), action: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: brandFilter(),
                                      );
                                    },
                                  ).then((_) {
                                    setState(
                                        () {}); // Forcer la mise à jour de l'interface
                                  });
                                }),
                                filterButton("Année",
                                    isFilterApplied: searchResultController
                                        .appliedFilters.value
                                        .contains('year'), action: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return yearFilter();
                                    },
                                  ).then((_) {
                                    setState(
                                        () {}); // Forcer la mise à jour de l'interface
                                  });
                                }),
                              ],
                            );
                          }),
                          Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sectionTitle(
                                    '${searchResultController.filteredCars.length} cars available'),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: searchResultController
                                        .filteredCars.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, index) {
                                      print(
                                          searchResultController.filteredCars);
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed('/car_details',
                                                  arguments:
                                                      searchResultController
                                                          .filteredCars[index]);
                                            },
                                            child: carComponent(
                                              title: searchResultController
                                                  .filteredCars[index].make,
                                              image:
                                                  "https://files.chillo.fr/${searchResultController.filteredCars[index].imagePathCar![0]}",
                                              rating: 4.95,
                                              commands: 120,
                                              price: searchResultController
                                                  .filteredCars[index].price,
                                            ),
                                          ),
                                          const SizedBox(height: 16.0),
                                        ],
                                      );
                                    }),
                              ],
                            );
                          }),
                          const SizedBox(height: 20.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 350,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(12.0),
                                          bottomRight: Radius.circular(12.0),
                                        ),
                                        child: Image.asset(Assets.car3)),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                          ),
                                          child: Image.asset(Assets.car4)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Column(
                                  children: [
                                    Text(
                                      "Louez, Roulez, Retournez – Aussi simple que ça!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        color: ColorStyle.fontColorLight,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Text(
                                      "Location de voiture simplifiée à portée de main, pour tout voyage, grand ou petit.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        color: ColorStyle.greyColor,
                                        fontSize: 16.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              PrimaryButton(
                                title: 'Parcourir les voitures',
                                onPressed: () {
                                  Get.toNamed('/bottom_nav');
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              return _searchBarController.isPlaceSearchActivated.value
                  ? topSheet(context, navigate: false)
                  : const SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  Widget filterButton(String text,
      {void Function()? action, bool isFilterApplied = false}) {
    return GestureDetector(
      onTap: () => Future.delayed(Duration.zero, action),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isFilterApplied
              ? ColorStyle.blackBackground
              : ColorStyle.containerBg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,
                style: GoogleFonts.lato(
                  color: isFilterApplied
                      ? ColorStyle.lightWhite
                      : ColorStyle.textBlackColor,
                  fontSize: 12.0,
                )),
            const SizedBox(
              width: 6.0,
            ),
            Icon(
              FontAwesomeIcons.chevronDown,
              size: 12.0,
              color: isFilterApplied
                  ? ColorStyle.lightWhite
                  : ColorStyle.textBlackColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.lato(
          color: ColorStyle.textBlackColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget priceFilter() {
    RangeValues currentRangeValues = const RangeValues(1, 50000);
    // const RangeValues(100000 / 3, 100000 / 1.4);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // This ensures the dialog only takes necessary space
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            height: 3.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: ColorStyle.containerBg,
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          Text(
            'Price',
            style: GoogleFonts.lato(
              color: ColorStyle.textBlackColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "£1 - £100,000",
            style: GoogleFonts.lato(
              color: ColorStyle.textBlackColor,
              fontSize: 16.0,
              // fontWeight: FontWeight.w300,
            ),
          ),
          RangeSlider(
            activeColor: ColorStyle.lightPrimaryColor,
            values: currentRangeValues,
            min: 1,
            max: 100000,
            // divisions: 10,
            labels: RangeLabels(
              '£${currentRangeValues.start.round()}',
              '£${currentRangeValues.end.round()}',
            ),
            onChanged: (RangeValues values) {
              // setState(() {
              //   _currentRangeValues = values;
              // });
            },
          ),
          PrimaryButton(
              title: 'Filtrer',
              onPressed: () async {
                searchResultController.carFilter.priceMin =
                    currentRangeValues.start;
                searchResultController.carFilter.priceMax =
                    currentRangeValues.end;

                searchResultController.appliedFilters.value.addIf(
                    !searchResultController.appliedFilters.value
                        .contains('price'),
                    'price');
                searchResultController.update();
                print(searchResultController.appliedFilters);
                await searchResultController.searchCar();
                Get.back();
                // Get.offNamed('/success_post');
              }),
        ],
      ),
    );
  }

  Widget yearFilter() {
    RangeValues currentRangeValues = const RangeValues(2000, 2024);
    // const RangeValues(100000 / 3, 100000 / 1.4);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // This ensures the dialog only takes necessary space
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            height: 3.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: ColorStyle.containerBg,
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          Text(
            'Année',
            style: GoogleFonts.lato(
              color: ColorStyle.textBlackColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "2000 - ${DateTime.now().year}",
            style: GoogleFonts.lato(
              color: ColorStyle.textBlackColor,
              fontSize: 16.0,
              // fontWeight: FontWeight.w300,
            ),
          ),
          RangeSlider(
            activeColor: ColorStyle.lightPrimaryColor,
            values: currentRangeValues,
            min: 2000,
            max: 2024,
            // divisions: 10,
            labels: RangeLabels(
              '£${currentRangeValues.start.round()}',
              '£${currentRangeValues.end.round()}',
            ),
            onChanged: (RangeValues values) {
              // setState(() {
              //   _currentRangeValues = values;
              // });
            },
          ),
          PrimaryButton(
              title: 'Filtrer',
              onPressed: () async {
                print("fhjdjkhfjdhfjd");
                searchResultController.carFilter.yearMin =
                    currentRangeValues.start.round();
                searchResultController.carFilter.yearMax =
                    currentRangeValues.end.round();
                searchResultController.appliedFilters.value.addIf(
                    !searchResultController.appliedFilters.value
                        .contains('year'),
                    'year');
                searchResultController.update();
                print(searchResultController.appliedFilters);

                await searchResultController.searchCar();

                Get.back();
                // Get.offNamed('/success_post');
              }),
        ],
      ),
    );
  }

  Widget typeFilter() {
    return StatefulBuilder(builder: (context, setStater) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(FontAwesomeIcons.close)),
                ),
                Text(
                  'Type',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    color: ColorStyle.fontColorLight,
                    fontSize: 20.0,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setStater(() {
                      // Réinitialise toutes les marques à non sélectionné
                      searchResultController.carTypes.forEach((brand) {
                        brand['isSelected'] = false;
                      });

                      // Active la première marque pour l'exemple
                      searchResultController.carTypes[0]['isSelected'] = true;

                      // Met à jour l'interface
                      searchResultController.update();
                    });
                    await searchResultController.searchCar();
                  },
                  child: Text('Réinitialiser',
                      style: GoogleFonts.lato(
                        color: ColorStyle.fontColorLight,
                        fontSize: 16.0,
                      )),
                ),
              ],
            ),
            Obx(() {
              return Column(
                children: searchResultController.carTypes.map((brand) {
                  return GestureDetector(
                    onTap: () {
                      setStater(() {
                        brand['isSelected'] = !brand['isSelected'];
                        searchResultController.update();
                      });
                    },
                    child: Column(
                      children: [
                        brandOrTypeComponent(
                            brand['type'], brand['isSelected'], setStater),
                        gapH12,
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
            gapH8,
            PrimaryButton(
                title: 'Filtrer',
                onPressed: () {
                  searchResultController.appliedFilters.value.addIf(
                      !searchResultController.appliedFilters.value
                          .contains('type'),
                      'type');
                  searchResultController.update();
                  print(searchResultController.appliedFilters);
                  Get.back();
                  // Get.offNamed('/success_post');
                })
          ],
        ),
      );
    });
  }

  Widget brandFilter() {
    return StatefulBuilder(builder: (context, setStater) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(FontAwesomeIcons.close)),
                ),
                Text(
                  'Marque',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    color: ColorStyle.fontColorLight,
                    fontSize: 20.0,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setStater(() {
                      // Réinitialise toutes les marques à non sélectionné
                      searchResultController.carBrands.forEach((brand) {
                        brand['isSelected'] = false;
                      });

                      // Active la première marque pour l'exemple
                      searchResultController.carBrands[0]['isSelected'] = true;

                      // Met à jour l'interface
                      searchResultController.update();
                    });
                    await searchResultController.searchCar();
                  },
                  child: Text('Réinitialiser',
                      style: GoogleFonts.lato(
                        color: ColorStyle.fontColorLight,
                        fontSize: 16.0,
                      )),
                ),
              ],
            ),
            Obx(() {
              return Column(
                children: searchResultController.carBrands.map((brand) {
                  return GestureDetector(
                    onTap: () {
                      setStater(() {
                        brand['isSelected'] = !brand['isSelected'];
                        searchResultController.update();
                      });
                    },
                    child: Column(
                      children: [
                        brandOrTypeComponent(
                            brand['name'], brand['isSelected'], setStater),
                        gapH12,
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
            gapH8,
            PrimaryButton(
                title: 'Filtrer',
                onPressed: () {
                  searchResultController.carFilter.make = searchResultController
                      .carBrands
                      .firstWhere((element) => element['isSelected'])['name'];
                  searchResultController.appliedFilters.value.addIf(
                      !searchResultController.appliedFilters.value
                          .contains('brand'),
                      'brand');
                  searchResultController.update();
                  print(searchResultController.appliedFilters);
                  Get.back();
                  // Get.offNamed('/success_post');
                })
          ],
        ),
      );
    });
  }

  Widget brandOrTypeComponent(
      String brand, bool value, void Function(void Function()) setStater) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Radio(
          value: value,
          groupValue: true,
          onChanged: (bool? value) {
            setStater(() {
              value = !value!;
              // searchResultController.carBrands.forEach((brand) {
              //   brand['isSelected'] = false;
              // });
              // searchResultController.carBrands
              //     .firstWhere((element) => element['brand'] == brand)['isSelected'] =
              //     true;
              // searchResultController.update();
            });
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(brand,
                style: GoogleFonts.lato(
                  color: ColorStyle.fontColorLight,
                  fontSize: 16.0,
                )),
            gapH6,
            Container(
              width: MediaQuery.of(context).size.width / 1.7,
              height: 2.0,
              decoration: const BoxDecoration(color: ColorStyle.grey),
            ),
          ],
        ),
      ],
    );
  }
}