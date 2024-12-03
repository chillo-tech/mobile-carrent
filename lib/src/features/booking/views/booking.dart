import '../../../../common/app_sizes.dart';
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

class Booking extends StatelessWidget {
  Booking({super.key});
  CarResponse carResponse = Get.arguments;

  // TODO: Remove this
  // Map<String, dynamic> carData = {
  //   "id": "6728d020c0cc901e4e2f6c3b",
  //   "make": "Mazda",
  //   "model": "CX30",
  //   "year": "2017",
  //   "condition": "5",
  //   "numberOfPlaces": 5,
  //   "imagePathCar": [
  //     "carrent/ad/6728d020c0cc901e4e2f6c3b/1730727968365_1000000033.jpg",
  //     "carrent/ad/6728d020c0cc901e4e2f6c3b/1730727968411_1000000034.jpg"
  //   ],
  //   "imagePathDocument":
  //       "carrent/ad/6728d020c0cc901e4e2f6c3b/1730727968477_IMG_20240910_130923.jpg",
  //   "phoneNumberProprietor": "+241612345678",
  //   "status": "En cours d'examen",
  //   "description": "This is a custom description",
  //   "typeCarburant": "Super",
  //   "evaluationOfCar": 5.0,
  //   "startDisponibilityDate": '25/11/2024 23:00',
  //   "endDisponibilityDate": '29/11/2024 23:00'
  // };

  BookingController _bookingController = Get.put(BookingController());

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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://files.chillo.fr/${carResponse.imagePathCar![0]}"),
                              fit: BoxFit.cover,
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
                              formatDateRangeFromStrings(
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
                              final DateTime? picked = await showDatePicker(
                                  fieldHintText: "Choisissez une date",
                                  locale: const Locale('fr'),
                                  fieldLabelText: "Date",
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030));
                              print(picked);
                              if (picked != null &&
                                  picked.toString() !=
                                      _bookingController
                                          .startBookingDate.value) {
                                _bookingController.startBookingDate(
                                    convertDate(picked.toString()));
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
                                              .startBookingDate.isNotEmpty
                                          ? _bookingController
                                              .startBookingDate.value
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
                              final DateTime? picked = await showDatePicker(
                                  fieldHintText: "Choisissez une date",
                                  locale: const Locale('fr'),
                                  fieldLabelText: "Date",
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030));
                              print(picked);
                              if (picked != null &&
                                  picked.toString() !=
                                      _bookingController.endBookingDate.value) {
                                _bookingController.endBookingDate(
                                    convertDate(picked.toString()));
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
                                              .endBookingDate.isNotEmpty
                                          ? (_bookingController
                                              .endBookingDate.value)
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
                      )
                    ],
                  ),
                  FormInputField(
                    labelText: 'Ajouter une carte de crédit',
                    placeholder: 'Numéro de carte',
                    hasCountry: false,
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    // prefixIcon: SvgPicture.asset(Assets.credit_card, width: 5.0,),
                    textInputType: TextInputType.phone,
                    // controller: loginController.loginEmailTextController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre numéro de carte';
                      }
                      return null;
                    },
                  ),
                  gapH8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FormInputField(
                        placeholder: 'MM/YY',
                        hasCountry: false,
                        isDoubleOnLine: true,
                        fillColor: ColorStyle.bgFieldGrey,
                        filled: true,
                        // prefixIcon: SvgPicture.asset(Assets.credit_card, width: 5.0,),
                        textInputType: TextInputType.phone,
                        // controller: loginController.loginEmailTextController,
                        fieldValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre numéro de carte';
                          }
                          return null;
                        },
                      ),
                      FormInputField(
                        placeholder: 'CVV',
                        hasCountry: false,
                        isDoubleOnLine: true,
                        fillColor: ColorStyle.bgFieldGrey,
                        filled: true,
                        // prefixIcon: SvgPicture.asset(Assets.credit_card, width: 5.0,),
                        textInputType: TextInputType.phone,
                        // controller: loginController.loginEmailTextController,
                        fieldValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre numéro de carte';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  gapH8,
                  FormInputField(
                    placeholder: 'Nom sur la carte',
                    hasCountry: false,
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    // prefixIcon: SvgPicture.asset(Assets.credit_card, width: 5.0,),
                    textInputType: TextInputType.phone,
                    // controller: loginController.loginEmailTextController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nom sur la carte';
                      }
                      return null;
                    },
                  )
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
                title: 'Next',
                onPressed: () {
                  Get.toNamed('/success_post', arguments: {
                    'image': Assets.success_withdraw,
                        'title': 'Votre réservation a été traitée avec succès',
                        'description':
                          "Vous recevrez un contrat confirmant la réservation, qui contiendra également les informations du propriétaire. Veuillez procéder à la récupération du véhicule.",
                        'buttonTitle': 'Continuer',
                        'route': '/bottom_nav'
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
