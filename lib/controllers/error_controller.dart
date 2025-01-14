import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/storage_constants.dart';
import '../network/app_exception.dart';
import '../src/features/settings/controllers/settings_controller.dart';
import 'toast_controller.dart';

class ErrorController {
  final SettingsController _settingsController = Get.put(SettingsController());
  String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  late ToastController toastController;
  void handleError(dynamic errorResponse) {
    try {
      print(errorResponse);

      String extractMessage(dynamic errorObj) {
        try {
          return errorObj['message'] ?? errorObj['detail'] ?? "";
        } catch (_) {
          return "";
        }
      }

      void handleCommonError(String message) {
        if (message.contains('Connection refused')) {
          showMessage('Connexion refusée'.tr);
        } else {
          showMessage(
              message.isNotEmpty ? message : "Une erreur s'est produite".tr);
        }
      }

      if (errorResponse is DioException) {
        final statusCode = errorResponse.response?.statusCode;
        if (statusCode == 403 || statusCode == 401) {
          _settingsController.logoutUser("Session expirée");
          return;
        }

        final responseBody = errorResponse.response?.data;
        final message = responseBody is String
            ? extractMessage(json.decode(responseBody))
            : extractMessage(responseBody);

        handleCommonError(message);
      } else if (errorResponse is AppException) {
        final statusCode = errorResponse.response?['statusCode'];
        if (statusCode == 403) {
          _settingsController.logoutUser("Session expirée");
          return;
        }

        final message = extractMessage(errorResponse.response);
        handleCommonError(message);
      } else {
        showMessage('Erreur inattendue'.tr);
        print(
            "Type d'erreur inattendu: ${errorResponse.runtimeType} $errorResponse");
      }
    } catch (error, stackTrace) {
      print('Unhandled error: $error');
      print('Stack trace: $stackTrace');
      showMessage('Erreur inattendue'.tr);
    }
  }


  void showMessage(message) {
    BotToast.showText(
      text: message,
      contentColor: Colors.grey.shade900,
      duration: const Duration(seconds: 3),
      textStyle: TextStyle(
        fontSize: 14,
        fontFamily: GoogleFonts.lato().fontFamily,
        color: Colors.white,
      ),
    );
  }

  // void logoutUser() async {
  //   var isLoggedIn = GetStorage().read(StorageConstants.loggedIn);
  //   isLoggedIn = isLoggedIn ?? false;
  //   if (isLoggedIn) {
  //     // HomeController homeController = Get.find();
  //     // homeController.logoutUser('session_expirée'.tr);
  //   }
  // }
}
