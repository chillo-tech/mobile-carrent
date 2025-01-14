import 'dart:io';

import 'package:carrent/common/app_sizes.dart';
import 'package:carrent/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../theme/theme.dart';
import '../../widgets/primary_button.dart';
import '../controller/withdraw_booking_controller.dart';

class BookingWithdraw extends StatelessWidget {
  BookingWithdraw({super.key});

  final BookingWithdrawController _withdrawBookingController =
      Get.put(BookingWithdrawController());
  BookingResponse booking = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            _withdrawBookingController.carImageFiles.clear();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Procedez au retrait",
                    style: GoogleFonts.lato(
                      color: ColorStyle.fontColorLight,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  gapH10,
                  Text(
                    "Téléchargez des photos de la voiture",
                    style: GoogleFonts.lato(
                      color: ColorStyle.hintColor,
                      fontSize: 16.0,
                    ),
                  ),
                  gapH10,
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      List<XFile> files = (await picker.pickMultiImage());
                      if (files.isNotEmpty) {
                        _withdrawBookingController.carImageFiles.value = files;
                        _withdrawBookingController.hasErrorOnCarImage(false);
                      }
                    },
                    child: Obx(() {
                      return _withdrawBookingController
                                  .carImageFiles.isNotEmpty &&
                              _withdrawBookingController
                                  .carImageFiles[0]!.path.isNotEmpty
                          ? Container(
                              width: double.infinity,
                              height: 150.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(_withdrawBookingController
                                      .carImageFiles[0]!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            )
                          : IntrinsicHeight(
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: ColorStyle.containerBg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(FontAwesomeIcons.camera,
                                        color: ColorStyle.hintColor,
                                        size: 20.0),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      "Ajouter des photos",
                                      style: GoogleFonts.lato(
                                        color: ColorStyle.hintColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                    }),
                  ),
                  gapH8,
                  Obx(() {
                    return _withdrawBookingController.hasErrorOnCarImage.value
                        ? Text(
                            "Selectionnez au moins une photo de la voiture",
                            style: GoogleFonts.lato(
                              color: ColorStyle.lightAccentColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : SizedBox();
                  }),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: PrimaryButton(
                      title: 'Continuer',
                      onPressed: () {
                        if (_withdrawBookingController.carImageFiles.isEmpty) {
                          _withdrawBookingController.hasErrorOnCarImage(true);
                          return;
                        }
                        // _withdrawBookingController.withdraw();
                        Get.toNamed('/confirm_otp', arguments: {
                          'operationType': 'car_withraw',
                          'booking': booking
                        });
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
