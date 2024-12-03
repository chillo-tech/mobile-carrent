import 'package:bot_toast/bot_toast.dart';
import 'package:carrent/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../common/storage_constants.dart';

class SettingsController extends GetxController {
  RxBool isNotificationsEnable = true.obs;
  UserController userController = Get.put(UserController());

  void logoutUser(String logoutMessage) async {
    var isLoggedIn = GetStorage().read(StorageConstants.loggedIn);
    isLoggedIn = isLoggedIn != null ? isLoggedIn : false;
    if (isLoggedIn) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
      GetStorage().write('lastLoginTime', formattedDate);
      GetStorage().remove(StorageConstants.loggedIn);
      GetStorage().remove(StorageConstants.refreshToken);
      GetStorage().remove('posts');
      userController.clearUserData();
      // GetStorage().remove(StorageConstants.sms);
      // GetStorage().remove(StorageConstants.email);

      BotToast.showText(
        text: logoutMessage,
        contentColor: Colors.grey.shade900,
        duration: Duration(seconds: 3),
        textStyle: TextStyle(
          fontSize: 14,
          fontFamily: GoogleFonts.lato().fontFamily,
          color: Colors.white,
        ),
      );

      Get.offNamedUntil(
          '/login', (route) => route.settings.name == '/auth-home');

      // try {
      //   final refreshToken = GetStorage().read('refreshToken');
      //   var req = {
      //     "client_id": "PUBLIC_CLIENT",
      //     "refresh_token": refreshToken,
      //   };
      //   AuthService authService = new AuthService();
      //   await authService.logout(req);
      // } catch (error) {
      //   errorController.handleError(error);
      // }
    }
  }
}
