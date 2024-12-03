import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/common_fonctions.dart';
import '../../../../helpers/assets.dart';
import '../../../../models/car_response.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/utility.dart';

class BookingsController extends GetxController {
  final CarResponse carResponse = Get.arguments;

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

  void executeActionOnTap(String action) {
    switch (action) {
      case 'booking_withdraw':
        Get.toNamed('/booking_withdraw', arguments: carResponse);
        break;
      case 'report_conflict':
        Get.bottomSheet(
          conflictSheet(carResponse: carResponse),
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
            // TODO: Implement vehicle booking cancellation
            onContinuePressed: () => Get.back(),
          ),
        );
        break;
      default:
        break;
    }
  }
}
