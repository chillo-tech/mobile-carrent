import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/booking.dart';

class ConflitController extends GetxController {
  // final ConflictRepository _conflictRepository = Get.find<ConflictRepository>();
  // final Conflict _conflict = Get.find<Conflict>();

  final RxList conflicts = [].obs;
  TextEditingController conflictDescription = TextEditingController();
  Rx<BookingResponse> conflitBooking = BookingResponse().obs;
  // final RxList<BookingResponse> bookings = <BookingResponse>[].obs;

  // @override
  // void onInit() {
  //   conflicts.bindStream(_conflictRepository.getConflicts());
  //   super.onInit();
  // }

  void reportAConflict() {
    Get.toNamed('/success', arguments: {
      'title': 'Conflit reporté',
      'description':
          'Nous vous contacterons tres bientot afin de résoudre ce conflit',
      'buttonTitle': 'Continuer',
      'route': '/bottom_nav'
    });
    // _conflictRepository.addConflict(conflict);
  }

  // void updateConflict(Conflict conflict) {
  //   _conflictRepository.updateConflict(conflict);
  // }

  // void deleteConflict(String id) {
  //   _conflictRepository.deleteConflict(id);
  // }
}
