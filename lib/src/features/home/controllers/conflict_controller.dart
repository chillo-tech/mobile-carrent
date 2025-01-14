import 'package:carrent/services/conflict.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/storage_constants.dart';
import '../../../../controllers/error_controller.dart';
import '../../../../env.dart';
import '../../../../models/booking.dart';
import 'package:http/http.dart' as http;

class ConflitController extends GetxController {
  // final ConflictRepository _conflictRepository = Get.find<ConflictRepository>();
  // final Conflict _conflict = Get.find<Conflict>();

  final RxList conflicts = [].obs;
  TextEditingController conflictDescription = TextEditingController();
  Rx<BookingResponse> conflitBooking = BookingResponse().obs;
  ErrorController errorController = ErrorController();
  // final RxList<BookingResponse> bookings = <BookingResponse>[].obs;

  // @override
  // void onInit() {
  //   conflicts.bindStream(_conflictRepository.getConflicts());
  //   super.onInit();
  // }

  // void reportAConflict() {
  //   // _conflictRepository.addConflict(conflict);
  // }

  void reportAConflict({required BookingResponse booking}) async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    ConflictService conflictService = ConflictService();
    try {
      await conflictService
          .reportAConflict(
              booking: booking, description: conflictDescription.text)
          .then((response) async {
        // myBookings.value = response;
        // print("---------------------");
        // print(response);
        Get.back();
        conflictDescription.clear();
        Get.toNamed('/success', arguments: {
          'title': 'Conflit reporté',
          'description':
              'Nous vous contacterons tres bientot afin de résoudre ce conflit',
          'buttonTitle': 'Continuer',
          'route': '/bottom_nav'
        });
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }
  // void updateConflict(Conflict conflict) {
  //   _conflictRepository.updateConflict(conflict);
  // }

  // void deleteConflict(String id) {
  //   _conflictRepository.deleteConflict(id);
  // }
}
