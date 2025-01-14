import 'package:carrent/common/app_sizes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/common_fonctions.dart';
import '../../../../common/storage_constants.dart';
import '../../../../helpers/assets.dart';
import '../../../../theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/primary_button.dart';
import '../controllers/bookings_controller.dart';

class Bookings extends StatefulWidget {
  Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  final BookingsController _bookingsController = Get.put(BookingsController());

  @override
  initState() {
    Future.delayed(Duration.zero, () {
      final loggedIn = GetStorage().read(StorageConstants.loggedIn);
      if (loggedIn != null && loggedIn) {
        _bookingsController.getMyBookings(launchLoader: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reservations",
            style: GoogleFonts.lato(
              color: ColorStyle.fontColorLight,
              fontWeight: FontWeight.w700,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Obx(() {
            return _bookingsController.myBookings.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _bookingsController.myBookings.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/booking_details',
                              arguments: _bookingsController.myBookings[index]);
                        },
                        child: bookingComponent(
                          context: context,
                          withdrawStatus: _bookingsController
                              .myBookings[index].withdrawStatus!,
                          reservationStatus: _bookingsController
                              .myBookings[index].reservationStatus!,
                          // status: _bookingsController.myBookings[index]['status'],
                          title:
                              '${_bookingsController.myBookings[index].car?.make} ${_bookingsController.myBookings[index].car?.model}',
                          image:
                              "https://files.chillo.fr/${_bookingsController.myBookings[index].car?.imagePathCar![0]}",
                          // description: _bookingsController.myBookings[index].description ??
                          price:
                              _bookingsController.myBookings[index].car?.price,
                          rating: _bookingsController
                              .myBookings[index].car?.reviewNumber,
                          orders: _bookingsController
                              .myBookings[index].car?.reservationNumber,
                        ),
                      );
                    })
                : Column(
                    children: [
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
                            isRoundedBorder: true,
                            title: 'Parcourir les voitures',
                            onPressed: () {
                              Get.offAllNamed('/bottom_nav');
                            },
                          )
                        ],
                      )
                    ],
                  );
          })
        ],
      ),
    );
  }

  Widget bookingComponent(
      {required BuildContext context,
      required String withdrawStatus,
      required String reservationStatus,
      title,
      price,
      image,
      rating,
      orders}) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(left: 7.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: ColorStyle.hintColor.withOpacity(0.11)),
            // height: 180.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          rowIconText(
                              Assets.bookmark,
                              // reservationStatus == 'En cours' ||
                              //         reservationStatus == 'Confirmé'
                              //     ? 'Ouvert'
                              //     : reservationStatus == 'Retiré'
                              //         ? 'Approuvré'
                              //         :
                              reservationStatus,
                              reservationStatus != 'En cours' &&
                                  reservationStatus != 'Confirmé',
                              reservationStatus == 'Validé'),
                          gapW8,
                          rowIconText(
                              getBookingIconByStatus(reservationStatus),
                              withdrawStatus == 'Récupéré' &&
                                      reservationStatus == 'Validé'
                                  ? 'Récupéré'
                                  : 'En attente',
                              false,
                              false),
                        ],
                      ),
                      const SizedBox(height: 7.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.lato(
                              color: ColorStyle.fontColorLight,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 7.0),
                          Row(
                            children: [
                              Text(
                                rating.toString(),
                                style: GoogleFonts.lato(
                                  color: ColorStyle.fontColorLight,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Icon(
                                Icons.star,
                                color: ColorStyle.lightPrimaryColor,
                                size: 18,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                "($orders commandes)",
                                style: GoogleFonts.lato(
                                  color: ColorStyle.fontColorLight,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7.0),
                          Text(
                            price + " par jour",
                            style: GoogleFonts.lato(
                              color: ColorStyle.fontColorLight,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Proceder au retrait',
                                style: GoogleFonts.lato(
                                  color: ColorStyle.fontColorLight,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Icon(FontAwesomeIcons.arrowRight)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3.7,
                    height: 180.0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0)),
                      // child: Image.asset(
                      //   image,
                      //   fit: BoxFit.cover,
                      // ),
                      // child: Image.network(
                      //   image,
                      //   fit: BoxFit.cover,
                      // ),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            // Retourne l'image une fois chargée
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorStyle.lightPrimaryColor,
                              backgroundColor: ColorStyle.grey,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
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
                    ),
                  ),
                )
              ],
            )),
        const SizedBox(height: 12.0),
      ],
    );
  }

  Widget rowIconText(
      String icon, String text, bool? isIconWhite, bool? isTextWhite) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        decoration: BoxDecoration(
            color: getBookingBackgroundColorByStatus(text),
            border: Border.all(
                color: getBookingBorderColorByStatus(text), width: 1.0),
            borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(icon,
                color: isIconWhite == true ? ColorStyle.white : null),
            // Icon(
            //   getIconByStatus(status),
            //   size: 17.0,
            //   color: getColorByStatus(status),
            // ),
            const SizedBox(width: 7.0),
            Text(
              text,
              style: GoogleFonts.lato(
                color: isTextWhite == true
                    ? ColorStyle.white
                    : getBookingColorByStatus(text),
                fontWeight: FontWeight.w700,
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
