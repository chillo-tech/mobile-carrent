import 'package:intl/intl.dart';

import '../../../../common/app_sizes.dart';
import '../../../../controllers/error_controller.dart';
import '../../../../models/car_response.dart';
import '../controllers/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/common_fonctions.dart';
import '../../../../helpers/assets.dart';
import '../../../../theme/theme.dart';
import '../../widgets/form_input_field.dart';
import '../../widgets/primary_button.dart';

class Booking extends StatefulWidget {
  Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  CarResponse carResponse = Get.arguments;

  final BookingController _bookingController = Get.put(BookingController());

// @override
//   void initState() {
//     _bookingController.isOnPageOpening(true);
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    // CarResponse carResponse = CarResponse.fromJson(carData);
    return Scaffold(
      backgroundColor: ColorStyle.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: ColorStyle.textBlackColor,
            size: 20.0,
          ),
        ),
        title: Text(
          "Retour",
          style: GoogleFonts.lato(
            color: ColorStyle.textBlackColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reserve a car',
                    style: GoogleFonts.lato(
                      color: ColorStyle.fontColorLight,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  gapH18,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 150.0,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Affiche un CircularProgressIndicator pendant le chargement
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                                // Image réseau avec gestion des erreurs
                                Image.network(
                                  carResponse.imagePathCar!.contains(
                                              'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg') ||
                                          carResponse.imagePathCar![0] ==
                                              'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg'
                                      ? 'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg'
                                      : "https://files.chillo.fr/${carResponse.imagePathCar![0]}",
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      // Retourne l'image une fois chargée
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: ColorStyle.lightPrimaryColor,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    // Retourne un placeholder ou un widget d'erreur si l'image échoue
                                    return Center(
                                      child: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 50.0,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      gapW10,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              carResponse.make,
                              style: GoogleFonts.lato(
                                color: ColorStyle.fontColorLight,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            gapH4,
                            Text(
                              formatDateRangewithYearFromStrings(
                                  carResponse.startDisponibilityDate!,
                                  carResponse.endDisponibilityDate!),
                              style: GoogleFonts.lato(
                                color: ColorStyle.fontColorLight,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            gapH4,
                            IntrinsicWidth(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: ColorStyle.lightGreyColor1,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(Assets.cash),
                                    gapW6,
                                    Text(
                                      '${carResponse.price} / jour',
                                      style: GoogleFonts.lato(
                                        color: ColorStyle.fontColorLight,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  gapH10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Plage de dates de disponibilité',
                        style: GoogleFonts.lato(
                          color: ColorStyle.fontColorLight,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // Add one day to the day
                              var initialDate = DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day + 1);
                              final DateTime? picked = await showDatePicker(
                                  fieldHintText: "Choisissez une date",
                                  locale: const Locale('fr'),
                                  fieldLabelText: "Date",
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: initialDate,
                                  lastDate: DateTime(2030));
                              print(picked);
                              // if (picked != null &&
                              //     picked.toString() !=
                              //         _bookingController
                              //             .bookingStartDate.value) {
                              //   _bookingController.bookingStartDate(
                              //       convertDate(picked.toString()));
                              // }
                              if (picked != null) {
                                _bookingController.bookingStartDate(
                                    convertDate(picked.toString()));
                                DateTime startDate = parseDate(
                                    _bookingController.bookingStartDate.value);
                                DateTime endDate = parseDate(
                                    _bookingController.bookingEndDate.value);

                                // Vérifier que la date de début ne soit pas après la date de fin
                                if (startDate.isAfter(endDate)) {
                                  _bookingController.isOnPageOpening(false);
                                  _bookingController.errorMessage(
                                      'La date de début ne peut pas être après la date de fin.');
                                  _bookingController.bookingStartDate('');
                                  // ErrorController().showMessage(
                                  //     'La date de début ne peut pas être après la date de fin.');
                                } else {
                                  _bookingController.bookingStartDate(
                                      convertDate(picked.toString()));
                                }
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
                                      _bookingController
                                              .bookingStartDate.isNotEmpty
                                          ? _bookingController
                                              .bookingStartDate.value
                                          : 'JJ/MM/AAAA',
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
                              // Add one day to the day
                              var initialDate = DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day + 1);
                              final DateTime? picked = await showDatePicker(
                                  fieldHintText: "Choisissez une date",
                                  locale: const Locale('fr'),
                                  fieldLabelText: "Date",
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: initialDate,
                                  lastDate: DateTime(2030));
                              print(picked);
                              // if (picked != null &&
                              //     picked.toString() !=
                              //         _bookingController.bookingEndDate.value) {
                              //   _bookingController.bookingEndDate(
                              //       convertDate(picked.toString()));
                              // }
                              if (picked != null) {
                                _bookingController.bookingEndDate(
                                    convertDate(picked.toString()));
                                DateTime startDate = parseDate(
                                    _bookingController.bookingStartDate.value);
                                DateTime endDate = parseDate(
                                    _bookingController.bookingEndDate.value);

                                // Vérifier que la date de fin ne soit pas avant la date de début
                                if (endDate.isBefore(startDate)) {
                                  _bookingController.isOnPageOpening(false);
                                  _bookingController.errorMessage(
                                      'La date de fin ne peut pas être avant la date de début.');
                                  _bookingController.bookingEndDate('');
                                  // ErrorController().showMessage(
                                  //     'La date de fin ne peut pas être avant la date de début.');
                                } else {
                                  _bookingController.bookingEndDate(
                                      convertDate(picked.toString()));
                                }
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
                                      _bookingController
                                              .bookingEndDate.isNotEmpty
                                          ? (_bookingController
                                              .bookingEndDate.value)
                                          : 'JJ/MM/AAAA',
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
                      Obx(() {
                        return (_bookingController.bookingStartDate.isEmpty ||
                                    _bookingController
                                        .bookingEndDate.isEmpty) &&
                                !_bookingController.isOnPageOpening.value
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _bookingController.errorMessage.value,
                                  style: GoogleFonts.lato(
                                    color: ColorStyle.lightPrimaryColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              )
                            : SizedBox();
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 30.0, bottom: 20.0),
              child: PrimaryButton(
                title: 'Suivant',
                onPressed: () {
                  _bookingController.isOnPageOpening(false);
                  DateTime selectedStartDate =
                      parseDate(_bookingController.bookingStartDate.value);
                  DateTime selectedEndDate =
                      parseDate(_bookingController.bookingEndDate.value);

                  DateTime bookingStartDate =
                      parseDate(carResponse.startDisponibilityDate!);
                  DateTime bookingEndDate =
                      parseDate(carResponse.endDisponibilityDate!);

                  if (_bookingController.bookingStartDate.value.isEmpty ||
                      _bookingController.bookingEndDate.value.isEmpty) {
                    _bookingController.isOnPageOpening(false);
                    _bookingController.errorMessage(
                        'Veuillez entrer une plage valide correspondante à la disponibilité du véhicule.');
                    return;
                  } else if (selectedStartDate.isBefore(bookingStartDate) ||
                      selectedEndDate.isAfter(bookingEndDate) ||
                      selectedStartDate.isAfter(bookingEndDate) ||
                      selectedEndDate.isBefore(bookingStartDate)) {
                    print(
                        'selectedStartDate.isBefore(bookingEndDate) $selectedEndDate  ${selectedStartDate.isBefore(bookingEndDate)}');
                    print(
                        'selectedEndDate.isAfter(bookingStartDate) ${selectedEndDate.isAfter(bookingStartDate)}');
                    _bookingController.isOnPageOpening(false);
                    _bookingController.errorMessage(
                        'Veuillez entrer une plage correspondante à la disponibilité du véhicule.');
                    _bookingController.bookingStartDate('');
                    _bookingController.bookingEndDate('');
                    // ErrorController().showMessage(
                    //     'La date de début ne peut pas être après la date de fin.');
                  } else if (_bookingController
                          .bookingStartDate.value.isNotEmpty &&
                      _bookingController.bookingEndDate.value.isNotEmpty) {
                    _bookingController.bookACar(
                      carId: carResponse.id,
                      carBrand: carResponse.make,
                      startDate: _bookingController.bookingStartDate.value,
                      endDate: _bookingController.bookingEndDate.value,
                    );
                  } else {
                    // _bookingController.hasClick(true);
                    return;
                  }
                  // Get.toNamed('/web_view', arguments: carResponse.make);
                  // Get.toNamed('/success_post', arguments: {
                  //   'image': Assets.success_withdraw,
                  //       'title': 'Votre réservation a été traitée avec succès',
                  //       'description':
                  //         "Vous recevrez un contrat confirmant la réservation, qui contiendra également les informations du propriétaire. Veuillez procéder à la récupération du véhicule.",
                  //       'buttonTitle': 'Continuer',
                  //       'route': '/bottom_nav'
                  //     });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
