import 'package:carrent/controllers/error_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/common_fonctions.dart';
import '../../../../common/storage_constants.dart';
import '../../../../env.dart';
import '../../../../helpers/assets.dart';
import '../../../../models/booking.dart';
import '../../../../models/car_response.dart';
import '../../../../services/booking.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/utility.dart';
import 'package:http/http.dart' as http;
import '../../withdraw_booking/controller/withdraw_booking_controller.dart';

class BookingsController extends GetxController {
  bool launchInitState = true;
  BookingsController({this.launchInitState = true});

  RxList<BookingResponse> myBookings = (List<BookingResponse>.of([])).obs;
  FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
  ErrorController errorController = ErrorController();

  TextEditingController descriptionController = TextEditingController();

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

  void executeActionOnTap(String action, BookingResponse booking) {
    // final CarResponse carResponse = Get.arguments.car;

    switch (action) {
      case 'booking_withdraw':
        Get.toNamed('/booking_withdraw', arguments: booking);
        break;
      case 'report_conflict':
        Get.bottomSheet(
          conflictSheet(bookingResponse: booking),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
        break;
      case 'cancel_booking':
        Get.dialog(
          Utility.simpleBinaryDialog(
            title: "Annuler la réservation",
            content: "Voulez-vous vraiment annuler cette réservation ?",
            onBackPressed: () => Get.back(),
            onContinuePressed: () => cancelMyBooking(booking: booking),
          ),
        );
        break;
      default:
        break;
    }
  }

  Future<void> getMyBookings({required bool launchLoader}) async {
    if (launchLoader) {
      Get.dialog(Center(
        child: CircularProgressIndicator(
          color: Get.theme.colorScheme.secondary,
        ),
      ));
    }
    BookingService bookingService = BookingService();
    String userId =
        await flutterSecureStorage.read(key: StorageConstants.id) ?? '';

    try {
      await bookingService.getBookings(userid: userId).then((response) async {
        myBookings.value = response;
        print("---------------------");
        print(response);
        if (launchLoader) {
          Get.back();
        }
      });
    } catch (error) {
      if (launchLoader) {
        Get.back();
      }
      errorController.handleError(error);
    }
  }

  void cancelMyBooking({required BookingResponse booking}) async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    BookingService bookingService = BookingService();
    try {
      await bookingService
          .cancelBooking(booking: booking)
          .then((response) async {
        // myBookings.value = response;
        // print("---------------------");
        // print(response);
        Get.back();
        Get.back();
        Get.toNamed('/success_post', arguments: {
          'image': Assets.success_withdraw,
          'title': "Réservation annulée",
          'description':
              "la reservation a été annulée avec succes, appuyez sur continuer pour procéder",
          'buttonTitle': 'Continuer',
          'route': '/bottom_nav'
        });
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }

  void withdrawACar({required BookingResponse booking}) async {
    BookingWithdrawController _withdrawBookingController = Get.find();
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    BookingService bookingService = BookingService();
    try {
      var request = http.MultipartRequest(
          'PUT', Uri.parse('${Env.getUserManagementApiBaseUrl()}reservation/remove/${booking.id}'));

      _withdrawBookingController.carImageFiles.forEach(
        (element) async {
          request.files.add(
            await http.MultipartFile.fromPath(
              'multipartFiles',
              element!.path,
            ),
          );
        },
      );

      String token = await GetStorage().read(StorageConstants.refreshToken);
      request.headers.putIfAbsent("Authorization", () => 'Bearer $token');

      await bookingService
          .withdrawBooking(request)
          .then((response) async {
        // myBookings.value = response;
        // print("---------------------");
        // print(response);
        Get.back();
        Get.toNamed('/success_post', arguments: {
          'image': Assets.success_withdraw,
          'title': "La prise en charge s'est déroulée sans problème !",
          'description':
              "La voiture a été récupérée avec succès, appuyez sur continuer pour procéder",
          'buttonTitle': 'Continuer',
          'route': '/bottom_nav'
        });
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }
}
