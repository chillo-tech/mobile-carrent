import 'dart:async';

import '../../../../../helpers/assets.dart';
import '../../forgot_password/controllers/forgot_password_controller.dart';
import '../../login/controllers/login_controller.dart';
import '../../register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  var _seconds = 0;
  var leftTime = "".obs;
  Timer? _timer;
  TextEditingController otpTextController = TextEditingController();
  RegisterController registerController = Get.put(RegisterController());
  ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    _seconds = Duration(seconds: 60).inSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      var leftDuration = Duration(seconds: _seconds);
      if (_seconds > 0) {
        final minutes = leftDuration.inMinutes;
        final seconds = leftDuration.inSeconds % 60;
        final minutesString = '$minutes'.padLeft(2, '0');
        final secondsString = '$seconds'.padLeft(2, '0');
        leftTime.value = "$minutesString:$secondsString";
      } else {
        leftTime.value = "00:00";
        stopTimer();
      }
    });
  }

  void onSubmitOTP(String operationType) {
    switch (operationType) {
      case "register":
        registerController.activateUser(otpTextController.text);
        stopTimer();
        break;
      case "login":
        Get.toNamed("/create_account");
        break;
      case "forgot_password":
        forgotPasswordController.validatePasscode(otpTextController.text);
        stopTimer();
        break;
      case "car_withraw":
        Get.toNamed('/success_post', arguments: {
          'image': Assets.success_withdraw,
          'title': "La prise en charge s'est déroulée sans problème !",
          'description':
              "La voiture a été récupérée avec succès, appuyez sur continuer pour procéder",
          'buttonTitle': 'Continuer',
          'route': '/bottom_nav'
        });
        break;
    }
  }

  void stopTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void onClose() {
    if (_timer != null) _timer?.cancel();
    otpTextController.dispose();
    stopTimer();
    super.onClose();
  }
}
