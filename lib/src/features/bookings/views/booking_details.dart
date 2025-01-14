import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrent/models/booking.dart';
import 'package:intl/intl.dart';
import '../../../../common/app_sizes.dart';
import '../../../../common/common_fonctions.dart';
import '../../../../controllers/toast_controller.dart';
import '../../../../models/car_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../helpers/assets.dart';
import '../../../../theme/theme.dart';
import '../../home/controllers/car_details_controller.dart';
import '../../widgets/form_input_field.dart';
import '../../widgets/primary_button.dart';
import '../controllers/bookings_controller.dart';

class BookingDetails extends StatefulWidget {
  BookingDetails({super.key});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  final BookingResponse bookingResponse = Get.arguments;
  CarResponse? carResponse;
  final _formKey = GlobalKey<FormState>();
  BookingsController bookingsController = Get.find();
  CarDetailsController carDetailsController =
      Get.put(CarDetailsController(carResponse: Get.arguments.car));
  int _currentIndex = 0;

  List<Review> reviews = [
    Review(
      image: Assets.woman_profile,
      name: 'Liora Ben-Ami',
      location: 'Manchester, UK',
      review:
          'La voiture était en bon état et le propriétaire était très sympathique. Je recommanderais cette voiture à tout le monde.',
    ),
    Review(
      image: Assets.man_profile,
      name: 'John Doe',
      location: 'Paris, France',
      review:
          "Professionnel et fiable. J'apprécie leur approche respectueuse de l'environnement.",
    ),
  ];

  List<Map<String, dynamic>> actions = [
    {
      'icon': Assets.white_car,
      'title': 'Retrait',
      'color': ColorStyle.lightPrimaryColor,
      'textColor': ColorStyle.lightWhiteBackground,
      'action': 'booking_withdraw',
    },
    {
      'icon': Assets.report,
      'title': 'Signaler un litige',
      'color': ColorStyle.lightGreyColor1,
      'textColor': ColorStyle.fontColorLight,
      'action': 'report_conflict',
    },
    {
      'icon': Assets.trash,
      'title': 'Annuler la réservation',
      'color': ColorStyle.lightGreyColor1,
      'textColor': ColorStyle.lightAccentColor,
      'action': 'cancel_booking',
    },
  ];

  @override
  initState() {
    super.initState();
    carResponse = bookingResponse.car;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> badges = [
      {
        'title': bookingResponse.reservationStatus == 'Ouvert'
            ? 'Reservé'
            : bookingResponse.reservationStatus == 'Validé'
                ? 'Récupéré'
                : bookingResponse.reservationStatus,
        'color': Color(0xFF777777),
        'textColor': ColorStyle.lightWhiteBackground,
      },
      {
        'icon': Assets.double_check,
        'title': '${double.parse(carResponse!.condition!).toInt()}/10',
        'color': ColorStyle.lightGreyColor1,
        'textColor': ColorStyle.fontColorLight,
      },
      {
        'icon': Assets.counter,
        'title': carDetailsController.formatTimeAgo(
          carResponse!.createdDate ?? "10/11/2024 23:00",
        ),
        'color': ColorStyle.lightGreyColor1,
        'textColor': ColorStyle.fontColorLight,
      },
    ];

    return Scaffold(
      backgroundColor: ColorStyle.lightWhiteBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: carResponse!.imagePathCar!.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24.0),
                              bottomRight: Radius.circular(24.0)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                "https://files.chillo.fr/$url",
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
                                      backgroundColor: ColorStyle.grey,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 30.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: ColorStyle.lightGreyColor1
                                              .withOpacity(0.3),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Text(
                                  '${_currentIndex + 1}/${carResponse!.imagePathCar!.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: carResponse!.imagePathCar!.map((url) {
                                  int index =
                                      carResponse!.imagePathCar!.indexOf(url);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentIndex == index
                                          ? ColorStyle.greyColor1
                                          : ColorStyle.lightWhite,
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${carResponse!.make} ${carResponse!.model}',
                        style: GoogleFonts.lato(
                          color: ColorStyle.fontColorLight,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      gapH8,
                      Obx(() {
                        return carDetailsController.reviews.isNotEmpty
                            ? Row(
                                children: [
                                  Text(
                                    '${((carDetailsController.reviews.map((review) => review.rating ?? 0).reduce((a, b) => a + b) / carDetailsController.reviews.length))}/5',
                                    style: GoogleFonts.lato(
                                      color: ColorStyle.fontColorLight,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  gapW6,
                                  headStarsFromRating(
                                      carDetailsController.reviews),
                                ],
                              )
                            : SizedBox();
                      }),
                      gapH8,
                      SizedBox(
                        height: 30.0,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemCount: badges.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: containerWithOrWithoutcon(
                                    text: badges[index]['title'] as String,
                                    icon: badges[index]['icon'] as String?,
                                    color: badges[index]['color'] as Color?,
                                    textColor:
                                        badges[index]['textColor'] as Color?,
                                    booking: bookingResponse),
                              );
                            }),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gapH16,
                          Text(
                            'Actions',
                            style: GoogleFonts.lato(
                              color: ColorStyle.fontColorLight,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          gapH10,
                          SizedBox(
                            height: 35.0,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: actions.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: containerWithOrWithoutcon(
                                        text: actions[index]['title'] as String,
                                        icon: actions[index]['icon'] as String,
                                        color: bookingResponse.reservationStatus != 'Annulé' &&
                                                bookingResponse.reservationStatus !=
                                                    'Validé' &&
                                                bookingResponse.reservationStatus !=
                                                    'En litige'
                                            ? actions[index]['color'] as Color?
                                            : ColorStyle.opacGrey,
                                        textColor: bookingResponse
                                                        .reservationStatus !=
                                                    'Annulé' &&
                                                bookingResponse.reservationStatus !=
                                                    'Validé' &&
                                                bookingResponse.reservationStatus !=
                                                    'En litige'
                                            ? actions[index]['textColor']
                                                as Color?
                                            : ColorStyle.lightWhite,
                                        action: bookingResponse.reservationStatus != 'Annulé' &&
                                                bookingResponse.reservationStatus !=
                                                    'Validé' &&
                                                bookingResponse.reservationStatus !=
                                                    'En litige'
                                            ? actions[index]['action'] as String
                                            : null,
                                        booking: bookingResponse),
                                  );
                                }),
                          ),
                        ],
                      ),
                      gapH16,
                      Column(
                        children: List.generate(
                          carDetailsController.carDetailsItems.length,
                          (index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: ColorStyle.lightGreyColor1,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: SvgPicture.asset(
                                          carDetailsController
                                              .carDetailsItems[index]['icon']!),
                                    ),
                                    gapW8,
                                    carDetailsController.carDetailsItems[index]
                                                ['description'] !=
                                            null
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                carDetailsController
                                                        .carDetailsItems[index]
                                                    ['title']!,
                                                style: GoogleFonts.lato(
                                                  color:
                                                      ColorStyle.fontColorLight,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                carDetailsController
                                                        .carDetailsItems[index]
                                                    ['description']!,
                                                style: GoogleFonts.lato(
                                                  color:
                                                      ColorStyle.fontColorLight,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            ],
                                          )
                                        : Text(
                                            carDetailsController
                                                    .carDetailsItems[index]
                                                ['title']!,
                                            style: GoogleFonts.lato(
                                              color: ColorStyle.fontColorLight,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                  ],
                                ),
                                gapH8,
                              ],
                            );
                          },
                        ),
                      ),
                      if (carResponse!.description != null &&
                          carResponse!.description!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapH10,
                            Text(
                              'Description du véhicule',
                              style: GoogleFonts.lato(
                                color: ColorStyle.fontColorLight,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            gapH8,
                            Text(
                              carResponse!.description!,
                              style: GoogleFonts.lato(
                                color: ColorStyle.greyColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      Obx(() {
                        return carDetailsController.reviews.isNotEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  gapH10,
                                  Text(
                                    'Avis des clients',
                                    style: GoogleFonts.lato(
                                      color: ColorStyle.fontColorLight,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  gapH10,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Note globale',
                                              style: GoogleFonts.lato(
                                                color:
                                                    ColorStyle.fontColorLight,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              (carDetailsController.reviews
                                                          .map((review) =>
                                                              review.rating ??
                                                              0)
                                                          .reduce(
                                                              (a, b) => a + b) /
                                                      carDetailsController
                                                          .reviews.length)
                                                  .toStringAsFixed(1),
                                              style: GoogleFonts.lato(
                                                color:
                                                    ColorStyle.fontColorLight,
                                                fontSize: 40.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            headStarsFromRating(
                                                carDetailsController.reviews,
                                                enableColor: ColorStyle
                                                    .lightPrimaryColor),
                                            Text(
                                              carDetailsController
                                                  .reviews.length
                                                  .toString(),
                                              style: GoogleFonts.lato(
                                                color: ColorStyle.grey,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: List.generate(5, (index) {
                                            int adjustedIndex = 5 - index;
                                            double progressValue =
                                                carDetailsController.reviews
                                                        .where((review) {
                                                      return review.rating ==
                                                          adjustedIndex;
                                                    }).length /
                                                    carDetailsController
                                                        .reviews.length;
                                            // =
                                            //     adjustedIndex / 5;
                                            return Row(
                                              children: [
                                                Text(
                                                  '$adjustedIndex',
                                                  style: GoogleFonts.lato(
                                                    color: ColorStyle.grey,
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                gapW6,
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  child:
                                                      LinearProgressIndicator(
                                                    minHeight: 6.0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    value: progressValue,
                                                    backgroundColor: ColorStyle
                                                        .lightGreyColor1,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            ColorStyle
                                                                .lightPrimaryColor),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      )
                                    ],
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        carDetailsController.reviews.length > 2
                                            ? 2
                                            : carDetailsController
                                                .reviews.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: reviewWidget(
                                          image: reviews[1].image!,
                                          name: carDetailsController
                                              .reviews[index]
                                              .userName!
                                              .capitalize!,
                                          location: '****@****.***',
                                          rate: carDetailsController
                                              .reviews[index].rating!,
                                          review: carDetailsController
                                              .reviews[index].review,
                                          date: carDetailsController
                                              .reviews[index].createdDate!,
                                        ),
                                      );
                                    },
                                  ),
                                  // gapH10,
                                  //       if (carDetailsController.reviews.length > 2)
                                  //         PrimaryButton(
                                  //             isRoundedBorder: true,
                                  //             color: ColorStyle.grey,
                                  //             textColor: ColorStyle.fontColorLight,
                                  //             title: 'Voir plus',
                                  //             onPressed: () {}),
                                ],
                              )
                            : SizedBox();
                      }),
                      gapH16,
                      Text(
                        'Noter le service',
                        style: GoogleFonts.lato(
                          color: ColorStyle.fontColorLight,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      gapH8,
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: AssetImage(Assets.car1),
                                ),
                                gapW8,
                                Row(
                                  children: List.generate(5, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        carDetailsController.rating(index);
                                      },
                                      child: Obx(() {
                                        return Icon(
                                          Icons.star,
                                          color: index <=
                                                  carDetailsController
                                                      .rating.value
                                              ? ColorStyle.textBlackColor
                                              : ColorStyle.bgFieldGrey,
                                          size: 20,
                                        );
                                      }),
                                    );
                                  }),
                                ),
                              ],
                            ),
                            gapH8,
                            FormInputField(
                              // labelText: 'Description (optionnel)',
                              placeholder: 'Entrez une note',
                              fillColor: ColorStyle.bgFieldGrey,
                              filled: true,
                              maxLines: 3,
                              textInputType: TextInputType.text,
                              controller: carDetailsController.reviewController,
                              fieldValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrez un avis';
                                }
                                return null;
                              },
                            ),
                            gapH18,
                            PrimaryButton(
                              isRoundedBorder: true,
                              color: ColorStyle.blackBackground,
                              textColor: ColorStyle.lightWhiteBackground,
                              title: 'Soumettre',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  carDetailsController.reviewAPost();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      // Obx(() {
                      //   return carDetailsController.cars.isNotEmpty
                      //       ? ListView.builder(
                      //           shrinkWrap: true,
                      //           itemCount: carDetailsController.cars.length,
                      //           physics: NeverScrollableScrollPhysics(),
                      //           itemBuilder: (BuildContext context, index) {
                      //             print(carDetailsController.cars);
                      //             return Column(
                      //               children: [
                      //                 GestureDetector(
                      //                   onTap: () {
                      //                     Get.toNamed('/booking_details',
                      //                         preventDuplicates: false,
                      //                         arguments: carDetailsController
                      //                             .cars[index]);
                      //                   },
                      //                   child: carComponent(
                      //                     title: carDetailsController
                      //                         .cars[index].make,
                      //                     image:
                      //                         "https://files.chillo.fr/${carDetailsController.cars[index].imagePathCar![0]}",
                      //                     rating: 4.95,
                      //                     commands: 120,
                      //                     price: carDetailsController
                      //                         .cars[index].price,
                      //                   ),
                      //                 ),
                      //                 const SizedBox(height: 16.0),
                      //               ],
                      //             );
                      //           })
                      //       : SizedBox();
                      // }),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 8),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: ColorStyle.lightWhiteBackground,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Réservé ${formatDateRangeFromStrings(bookingResponse.startDate!, bookingResponse.endDate!)}",
                            style: GoogleFonts.lato(
                              color: ColorStyle.fontColorLight,
                              fontSize: 14.0,
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
                                    '${carResponse!.price} FCFA / jour',
                                    style: GoogleFonts.lato(
                                      color: ColorStyle.fontColorLight,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      PrimaryButton(
                        isHalfWidth: true,
                        title: 'Récupérer la voiture',
                        color: bookingResponse.reservationStatus != 'Annulé' &&
                                bookingResponse.reservationStatus != 'Validé' &&
                                bookingResponse.reservationStatus != 'En litige'
                            ? ColorStyle.lightPrimaryColor
                            : ColorStyle.opacGrey,
                        onPressed: bookingResponse.reservationStatus !=
                                    'Annulé' &&
                                bookingResponse.reservationStatus != 'Validé' &&
                                bookingResponse.reservationStatus != 'En litige'
                            ? () {
                                // Get.bottomSheet(
                                //   conflictSheet(carResponse: carResponse),
                                //   isScrollControlled: true,
                                //   backgroundColor: Colors.transparent,
                                // );
                                Get.toNamed('/booking_withdraw',
                                    arguments: bookingResponse);
                              }
                            : () {},
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget containerWithOrWithoutcon(
      {required String text,
      String? icon,
      Color? color = ColorStyle.lightGreyColor1,
      Color? textColor = ColorStyle.fontColorLight,
      String? action,
      required BookingResponse booking}) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          if (action != null)
            bookingsController.executeActionOnTap(action!, booking);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: icon != null
              ? Row(
                  children: [
                    SvgPicture.asset(icon, color: textColor),
                    gapW6,
                    Text(
                      text,
                      style: GoogleFonts.lato(
                        color: textColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              : Text(
                  text,
                  style: GoogleFonts.lato(
                    color: textColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ),
      ),
    );
  }

  Widget reviewWidget(
      {required String image,
      required String name,
      required int rate,
      required String location,
      required String review,
      required String date}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: const BoxDecoration(
                    color: ColorStyle.lightPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    name[0],
                    style: GoogleFonts.lato(
                      color: ColorStyle.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: index <= (rate - 1)
                          ? ColorStyle.lightPrimaryColor
                          : ColorStyle.bgFieldGrey,
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
            gapW8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        location,
                        style: GoogleFonts.lato(
                          color: ColorStyle.grey,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        carDetailsController.formatTimeAgo(date),
                        style: GoogleFonts.lato(
                          color: ColorStyle.grey,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        gapH4,
        Text(
          review,
          style: GoogleFonts.lato(
            color: ColorStyle.fontColorLight,
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
