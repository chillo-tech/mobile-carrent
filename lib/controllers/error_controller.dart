import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/storage_constants.dart';
import '../network/app_exception.dart';
import 'toast_controller.dart';

class ErrorController {
  String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  late ToastController toastController;
  handleError(errorResponseString) {
    print(errorResponseString);
    try {
      if (errorResponseString is DioException) {
        var errorObj = json.decode(errorResponseString.response.toString());
        var statusCode = errorObj['status'];
        if (statusCode == 403) {
          logoutUser();
        } else {
          var message = errorObj['message'] ?? errorObj['detail'];
          if (message.contains('Connection refused')) {
            showMessage('Connexion refusée'.tr);
          } else {
            if (message.isEmpty) message = "Une erreur s'est produite".tr;
            showMessage(message);
          }
        }
      } else if (errorResponseString is AppException) {
        // var response = errorResponseString.response.toString();
        var errorObj = errorResponseString.response;
        print('${errorResponseString.response}');
        if (errorObj['statusCode'] == 403) {
          logoutUser();
        } else {
          var message = errorObj['message'];
          if (message.contains('Connection refused')) {
            showMessage('Connexion refusée'.tr);
          } else {
            if (message.isEmpty) message = "une_erreur_s'est_produite".tr;
            showMessage(message);
          }
        }
      } else {
        // Handle other types of errors if needed
        showMessage('Erreur inattendue'.tr);
        print(
            'Type d\'erreur inattendu de: ${errorResponseString.runtimeType} $errorResponseString');
      }
    } catch (error) {
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

  void logoutUser() async {
    var isLoggedIn = GetStorage().read(StorageConstants.loggedIn);
    isLoggedIn = isLoggedIn ?? false;
    if (isLoggedIn) {
      // HomeController homeController = Get.find();
      // homeController.logoutUser('session_expirée'.tr);
    }
  }
}
