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

RegExp emailRegex() {
  return RegExp(
      r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
}

String convertDate(String inputDate) {
  DateTime dateTime = DateTime.parse(inputDate);
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  String year = dateTime.year.toString();
  return '$day/$month/$year';
}

String convertDateToDayMonthYear(String inputDate) {
  // Parse la date
  DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(inputDate);

  return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
}

String convertDateToPlainString(String inputDate) {
  // Parse la date
  DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(inputDate);

  // Formatte la date au format souhaité
  String formattedDate = DateFormat("EEE d MMM", 'fr_FR').format(parsedDate);

  return formattedDate; // Résultat : Sam 10 Nov
}

String formatDateRangeFromStrings(String startDateStr, String endDateStr) {
  // Format pour analyser les chaînes de date
  final inputFormat = DateFormat('dd/MM/yyyy');

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

String formatDateRangewithYearFromStrings(
    String startDateStr, String endDateStr) {
  // Format pour analyser les chaînes de date
  final inputFormat = DateFormat('dd/MM/yyyy');

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

  final SearchResultController searchResultController = Get.find();
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
            // Padding(
            //   padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
            //   child: Text(
            //     'Ou',
            //     style: GoogleFonts.lato(
            //       color: ColorStyle.textBlackColor,
            //       fontSize: 16.0,
            //       // fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
            // FormInputField(
            //   // labelText: "",
            //   placeholder: "N'importe ou",
            //   fillColor: ColorStyle.bgFieldGrey,
            //   filled: true,
            //   textInputType: TextInputType.emailAddress,
            //   focusNode: locationFocusNode,
            //   controller: searchBarController.searchPlace,
            //   // fieldValidator: (value) {
            //   //   if (value == null || value.isEmpty) {
            //   //     return 'Please enter your location';
            //   //   }
            //   //   return null;
            //   // },
            // ),
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
                      // Get.toNamed('/search_result');
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
          // child: Image.network(
          //   image,
          //   fit: BoxFit.cover,
          //   height: 180.0,
          //   width: double.infinity,
          // ),
          child: Image.network(
            image,
            fit: BoxFit.cover,
            height: 180.0,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                // Retourne l'image une fois chargée
                return child;
              }
              return Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: CircularProgressIndicator(
                    color: ColorStyle.lightPrimaryColor,
                    backgroundColor: ColorStyle.grey,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
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
    {final BookingResponse? bookingResponse,
    List<BookingResponse> bookings = const []}) {
  ConflitController conflitcontroller = Get.put(ConflitController());
  final _formKey = GlobalKey<FormState>();
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
        child: Form(
          key: _formKey,
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
                  bookingResponse != null
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
                                text:
                                    "${bookingResponse.car?.make} ${bookingResponse.car?.model}",
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
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la description du conflit';
                      }
                      return null;
                    },
                  )
                ],
              ),
              gapH18,
              PrimaryButton(
                title: 'Soumettre',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    conflitcontroller.reportAConflict(
                        booking: bookings.isNotEmpty
                            ? conflitcontroller.conflitBooking.value
                            : bookingResponse!);
                  }
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Color getPostColorByStatus(String status) {
  switch (status) {
    case 'In review':
      return ColorStyle.hintColor;
    case 'Approved':
      return ColorStyle.success;
    case 'Not Approved':
      return ColorStyle.lightPrimaryColor;
    default:
      return ColorStyle.success;
  }
}

Color getPostBorderColorByStatus(String status) {
  switch (status) {
    case 'In review':
      return ColorStyle.white;
    case 'Approved':
      return ColorStyle.success;
    case 'Not Approved':
      return ColorStyle.lightPrimaryColor;
    default:
      return ColorStyle.success;
  }
}

IconData getPostIconByStatus(String status) {
  switch (status) {
    case 'In review':
      return FontAwesomeIcons.clock;
    case 'Approved':
      return FontAwesomeIcons.checkCircle;
    case 'Not Approved':
      return FontAwesomeIcons.close;
    default:
      return FontAwesomeIcons.checkCircle;
  }
}

Color getBookingColorByStatus(String status) {
  switch (status.toLowerCase()) {
    case 'en cours' || 'ouvert' || 'confirmé':
      return ColorStyle.hintColor;
    case 'not approved' || 'en attente':
      return Color(0xFFBF1C30);
    case 'annulé' || 'en litige':
      return ColorStyle.white;
    case 'retiré' || 'récupéré':
      return ColorStyle.success;
    default:
      return ColorStyle.success;
  }
}

Color getBookingBackgroundColorByStatus(String status) {
  switch (status.toLowerCase()) {
    case 'en cours' || 'ouvert' || 'retiré' || 'récupéré' || 'confirmé':
      return ColorStyle.bgFieldGrey;
    case 'approved':
      return ColorStyle.success;
    case 'not approved' || 'annulé' || 'en litige':
      return Color(0xFFBF1C30);
    case 'en attente':
      return Color(0xFFFEEDEF);
    default:
      return ColorStyle.success;
  }
}

Color getBookingBorderColorByStatus(String status) {
  switch (status.toLowerCase()) {
    case 'en cours' || 'ouvert' || 'confirmé':
      return ColorStyle.white;
    case 'Approved':
      return ColorStyle.success;
    case 'not approved' || 'annulé' || 'en attente' || 'en litige':
      return Color(0xFFF9A7B1);
    case 'retiré' || 'récupéré':
      return Color(0xFFECFBF3);
    default:
      return ColorStyle.success;
  }
}

String getBookingIconByStatus(String status) {
  switch (status) {
    case 'Validé':
      return Assets.check;
    default:
      return Assets.alert_inverse;
  }
}

Widget headStarsFromRating(List<Review> reviews, {Color enableColor = Colors.yellow}) {
  return Row(
    children: List.generate(5, (index) {
      final averageRating =
          reviews.map((review) => review.rating ?? 0).reduce((a, b) => a + b) /
              reviews.length;

      final fullStar = averageRating.floor(); // Nombre d'étoiles pleines
      final hasPartialStar = averageRating - fullStar > 0; // Étoile partielle

      if (index < fullStar) {
        // Étoiles pleines
        return Icon(Icons.star, color: enableColor, size: 18);
      } else if (index == fullStar && hasPartialStar) {
        // Étoile partielle
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final fraction = (averageRating - fullStar).clamp(0.0, 1.0);
            return LinearGradient(
              stops: [fraction, fraction],
              colors: [enableColor, ColorStyle.bgFieldGrey],
            ).createShader(bounds);
          },
          child: Icon(Icons.star, color: enableColor, size: 18),
        );
      } else {
        // Étoiles vides
        return Icon(Icons.star, color: ColorStyle.bgFieldGrey, size: 18);
      }
    }),
  );
}
