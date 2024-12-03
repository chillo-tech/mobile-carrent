import 'package:carrent/src/features/home/controllers/conflict_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../helpers/assets.dart';
import '../models/booking.dart';
import '../models/car_response.dart';
import '../src/features/search/controllers/search_controller.dart';
import '../src/features/search_result/controllers/search_result_controller.dart';
import '../src/features/widgets/form_input_field.dart';
import '../src/features/widgets/primary_button.dart';
import '../theme/theme.dart';
import 'app_sizes.dart';

String convertDate(String inputDate) {
  DateTime dateTime = DateTime.parse(inputDate);
  String day = dateTime.day.toString();
  // String month = getMonthName(dateTime.month);
  String year = dateTime.year.toString();
  return '$day/${dateTime.month}/$year';
}

String convertDateToDayMonthYear(String inputDate) {
  // Parse la date
  DateTime parsedDate = DateFormat("dd/MM/yyyy HH:mm").parse(inputDate);

  return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
}

String convertDateToPlainString(String inputDate) {
  // Parse la date
  DateTime parsedDate = DateFormat("dd/MM/yyyy HH:mm").parse(inputDate);

  // Formatte la date au format souhaité
  String formattedDate = DateFormat("EEE d MMM", 'fr_FR').format(parsedDate);

  return formattedDate; // Résultat : Sam 10 Nov
}

String formatDateRangeFromStrings(String startDateStr, String endDateStr) {
  // Format pour analyser les chaînes de date
  final inputFormat = DateFormat('dd/MM/yyyy HH:mm');

  // Format de sortie pour afficher les dates
  final outputFormat = DateFormat('d MMM');

  // Convertir les chaînes en objets DateTime
  DateTime startDate = inputFormat.parse(startDateStr);
  DateTime endDate = inputFormat.parse(endDateStr);

  // Formater les dates
  final start = outputFormat.format(startDate);
  final end = outputFormat.format(endDate);

  // Retourner la plage de dates
  return '$start - $end';
}

String formatDateRangewithYearFromStrings(String startDateStr, String endDateStr) {
  // Format pour analyser les chaînes de date
  final inputFormat = DateFormat('dd/MM/yyyy HH:mm');

  // Format de sortie pour afficher les dates
  final outputFormat = DateFormat('d MMM yy');

  // Convertir les chaînes en objets DateTime
  DateTime startDate = inputFormat.parse(startDateStr);
  DateTime endDate = inputFormat.parse(endDateStr);

  // Formater les dates
  final start = outputFormat.format(startDate);
  final end = outputFormat.format(endDate);

  // Retourner la plage de dates
  return '$start - $end';
}

Widget topSheet(BuildContext context, {bool navigate = true}) {
  final FocusNode locationFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  final SearchBarController searchBarController =
      Get.put(SearchBarController());

  final SearchResultController searchResultController =
      Get.put(SearchResultController());
  locationFocusNode.requestFocus();
  return Form(
    key: formKey,
    child: IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.only(
            bottom: 20.0, left: 16.0, right: 16.0, top: 16.0),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  searchBarController.isPlaceSearchActivated.value = false;
                },
                child: const Icon(FontAwesomeIcons.arrowLeft)),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
              child: Text(
                'Ou',
                style: GoogleFonts.lato(
                  color: ColorStyle.textBlackColor,
                  fontSize: 16.0,
                  // fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FormInputField(
              // labelText: "",
              placeholder: "N'importe ou",
              fillColor: ColorStyle.bgFieldGrey,
              filled: true,
              textInputType: TextInputType.emailAddress,
              focusNode: locationFocusNode,
              controller: searchBarController.searchPlace,
              // fieldValidator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter your location';
              //   }
              //   return null;
              // },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
              child: Text(
                "Date de disponibilite",
                style: GoogleFonts.lato(
                  color: ColorStyle.textBlackColor,
                  fontSize: 16.0,
                  // fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                        fieldHintText: "Choissez une date",
                        locale: const Locale('fr'),
                        fieldLabelText: "Date",
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030));
                    print(picked);
                    if (picked != null &&
                        picked.toString() !=
                            searchBarController.startAvailableDate.value) {
                      searchBarController
                          .startAvailableDate(convertDate(picked.toString()));
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width / 3.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorStyle.containerBg,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() {
                          return Text(
                            searchBarController.startAvailableDate.isNotEmpty
                                ? searchBarController.startAvailableDate.value
                                : 'DD/MM/YYY',
                            style: GoogleFonts.lato(
                              color: ColorStyle.hintColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                        fieldHintText: "Choissez une date",
                        locale: const Locale('fr'),
                        fieldLabelText: "Date",
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030));
                    print(picked);
                    if (picked != null &&
                        picked.toString() !=
                            searchBarController.endAvailableDate.value) {
                      searchBarController
                          .endAvailableDate(convertDate(picked.toString()));
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width / 3.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorStyle.containerBg,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() {
                          return Text(
                            searchBarController.endAvailableDate.isNotEmpty
                                ? searchBarController.endAvailableDate.value
                                : 'DD/MM/YYY',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: ColorStyle.hintColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width / 4.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: ColorStyle.containerBg,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.calendar,
                        height: 14.0,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      const Icon(
                        FontAwesomeIcons.chevronDown,
                        size: 12.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
            gapH16,
            PrimaryButton(
                title: 'Rechercher',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    searchBarController.isPlaceSearchActivated(false);
                    if (navigate) {
                      searchResultController.carFilter.startDisponibilityDate =
                          searchBarController.startAvailableDate.value;
                      searchResultController.carFilter.endDisponibilityDate =
                          searchBarController.endAvailableDate.value;
                      await searchResultController.searchCar();
                      Get.toNamed('/search_result');
                    }
                    // _searchBarController.createPost();
                  }
                  // Get.offNamed('/success_post');
                })
          ],
        ),
      ),
    ),
  );
}

Widget carComponent(
    {required String title, required String image, rating, commands, price}) {
  return Container(
    padding: const EdgeInsets.only(bottom: 16.0),
    decoration: const BoxDecoration(
      color: ColorStyle.carComponentBg,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
          child: Image.network(
            image,
            fit: BoxFit.cover,
            height: 180.0,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            title,
            style: GoogleFonts.lato(
              color: ColorStyle.fontColorLight,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Text(
                "$rating",
                style: GoogleFonts.lato(
                  color: ColorStyle.fontColorLight,
                  fontSize: 14.0,
                ),
              ),
              SvgPicture.asset(Assets.star),
              Text(
                "($commands commandes)",
                style: GoogleFonts.lato(
                  color: ColorStyle.fontColorLight,
                  fontSize: 14.0,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "$price FCFA /jour",
                style: GoogleFonts.lato(
                  color: ColorStyle.fontColorLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget conflictSheet(
    {final CarResponse? carResponse,
    List<BookingResponse> bookings = const []}) {
  ConflitController conflitcontroller = Get.put(ConflitController());
  return IntrinsicHeight(
    child: GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorStyle.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0))),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gérer un conflit',
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                gapH18,
                carResponse != null
                    ? Text.rich(
                        style: GoogleFonts.lato(
                          color: ColorStyle.fontColorLight,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        TextSpan(
                          text: 'Reservation: ',
                          children: [
                            TextSpan(
                              text: "${carResponse.make} ${carResponse.model}",
                              style: GoogleFonts.lato(
                                color: ColorStyle.lightPrimaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : DropdownButtonFormField(
                        validator: (value) {
                          if (value == null) {
                            // if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner une réservation';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorStyle.bgFieldGrey,
                          labelText: 'Sélectionnez le service en conflit',
                          labelStyle: GoogleFonts.lato(
                            color: ColorStyle.hintColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: bookings
                            .map((booking) => DropdownMenuItem(
                                  value: booking,
                                  child: Text(booking.car?.make ?? ''),
                                ))
                            .toList(),
                        onChanged: (value) {
                          conflitcontroller.conflitBooking(value);
                        },
                      ),
                gapH20,
                FormInputField(
                  labelText: 'Description',
                  placeholder: 'Entrez la description du conflit',
                  fillColor: ColorStyle.bgFieldGrey,
                  filled: true,
                  maxLines: 3,
                  textInputType: TextInputType.text,
                  controller: conflitcontroller.conflictDescription,
                  // fieldValidator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter the daily rental price of the vehicle';
                  //   }
                  //   return null;
                  // },
                )
              ],
            ),
            gapH18,
            PrimaryButton(
              title: 'Soumettre',
              onPressed: () {},
            )
          ],
        ),
      ),
    ),
  );
}
