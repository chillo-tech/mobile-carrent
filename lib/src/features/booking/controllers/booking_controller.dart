import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../../common/storage_constants.dart';
import '../../../../controllers/error_controller.dart';
import '../../../../services/booking.dart';
import '../../../../utils/utility.dart';

class BookingController extends GetxController {
  ErrorController errorController = ErrorController();
  final RxString bookingStartDate = ''.obs;
  final RxString bookingEndDate = ''.obs;
  FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

  void bookACar(
      {required String carId,
      required String carBrand,
      required String startDate,
      required String endDate}) async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    BookingService bookingService = BookingService();

    try {
      String phone =
          await flutterSecureStorage.read(key: StorageConstants.phone) ?? '';
      String userId =
          await flutterSecureStorage.read(key: StorageConstants.id) ?? '';
      // Booking request object
      var requestObject = {
        "startDate": bookingStartDate.value,
        "endDate": bookingEndDate.value,
        "phoneNumberReservation": phone, // "+237678424125",
        "idCar": carId,
        "userId": userId
      };
      // Check if login details are correct by authenticating

      await bookingService.bookACar(requestObject).then((response) async {
        print("---------------------");
        print(response);
        Get.back();
        if (response['Link'] != null && response['Link']!.isNotEmpty) {
          var isPaymentSuccess = await Get.toNamed(
            '/web_view',
            arguments: {
              'car': carBrand,
              'url': response['Link'],
            },
          );

          if (isPaymentSuccess != null && isPaymentSuccess) {
            Get.dialog(
              Utility.simpleDialog(
                title: "Réservation réussie",
                content: "Votre réservation a été confirmée.",
                continueButtonText: 'Continuer',
                onContinuePressed: () => Get.offAllNamed('/bottom_nav'),
              ),
            );
          } else {
            Get.dialog(
              Utility.simpleBinaryDialog(
                title: "Réservation échouée",
                content: "Votre réservation a échouée.",
                backButtonText: 'Annuler',
                continueButtonText: 'Reessayer',
                onBackPressed: () => Get.offAllNamed('/bottom_nav'),
                onContinuePressed: () {
                  Get.back();
                  bookACar(
                      carId: carId,
                      carBrand: carBrand,
                      startDate: startDate,
                      endDate: endDate);
                },
              ),
            );
          }
          // } else {
          // Get.dialog(
          //   AlertDialog(
          //   title: Text('Booking Failed'),
          //   content: Text('Your booking for $carBrand could not be completed.'),
          //   actions: [
          //     TextButton(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     child: Text('OK'),
          //     ),
          //   ],
          //   ),
          // );
          // }
        }
        // if (response != null &&
        //     response.user.id != null &&
        //     response.user.id.isNotEmpty) {
        //   await _userController.saveUserData(response);
        //   Get.back();

        //   GetStorage().write(StorageConstants.refreshToken, response.token);
        //   GetStorage().write(StorageConstants.loggedIn, true);
        //   Get.offAllNamed('/bottom_nav');
        // }
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }
}
