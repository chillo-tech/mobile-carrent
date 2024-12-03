import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/storage_constants.dart';
import '../../../models/carrent_country.dart';
import '../../../theme/theme.dart';
import '../../../utils/utility.dart';

class CountriesDropdown extends StatefulWidget {
  /// Dropdown to show countries list.
  /// Set the `cached` property to `true` to persists the selected
  /// country into the phone cache. Caching is disabled by default.
  const CountriesDropdown({
    Key? key,
    required this.countries,
    this.value,
    required this.onChanged,
    this.cached = false,
  }) : super(key: key);

  final bool cached;
  final CarrentCountry? value;
  final List<CarrentCountry> countries;
  final Function(CarrentCountry country) onChanged;

  @override
  State<CountriesDropdown> createState() => _CountriesDropdownState();
}

class _CountriesDropdownState extends State<CountriesDropdown> {
  CarrentCountry? _selectedCountry;
  RxList<CarrentCountry> _filteredCountries = RxList.empty();

  @override
  void initState() {
    _resetCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorStyle.lightWhite, borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13.5),
      child: InkWell(
        onTap: () => _showCountries(context),
        child: AbsorbPointer(
          absorbing: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Utility.getImageFromBase64String(_selectedCountry?.flag ?? ""),
              const SizedBox(width: 8.0),
              Icon(
                FontAwesomeIcons.chevronDown,
                size: 16.0,
                color: Colors.grey.shade900,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show filtered countries list inside a dialog.
  /// Change the implementation of this function to change
  /// the way the countries list are displayed.
  void _showCountries(BuildContext context) {
    _resetCountries();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Code de pays'.tr,
            style: GoogleFonts.inter(),
          ),
          content: Obx(
            () {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 2.0,
                width: double.maxFinite,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.search),
                        labelText: 'Rechercher'.tr,
                      ),
                      onChanged: (value) => _filterCountries(value),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filteredCountries.length,
                        itemBuilder: (context, index) {
                          CarrentCountry _country = _filteredCountries[index];

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCountry = _country;
                              });

                              widget.onChanged(_country);
                              if (widget.cached) {
                                GetStorage().write(StorageConstants.countryName,
                                    _country.shortName);
                                GetStorage().write(
                                    StorageConstants.selectedPhoneCode,
                                    _country.phonecode);
                              }

                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Utility.getImageFromBase64String(
                                            _country.flag ?? ""),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "${_country.shortName} (+${_country.phonecode})",
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                              color: Colors.grey.shade900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_selectedCountry?.shortName ==
                                      _country.shortName)
                                    Icon(
                                      Icons.done,
                                      size: 20.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const Divider(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () => Get.back(),
            ),
          ],
        );
      },
    );
  }

  /// Search & filter countries list based on given query.
  /// `query` can be a phone prefix or country name.
  void _filterCountries(String query) {
    var results = widget.countries.where((country) {
      return (country.shortName?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          country.phonecode
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
    }).toList();

    _filteredCountries.assignAll(results);
  }

  /// Reset countries list to default state.
  void _resetCountries() {
    _filteredCountries.assignAll(widget.countries);
    _selectedCountry = widget.value ?? _filteredCountries[0];
  }
}
