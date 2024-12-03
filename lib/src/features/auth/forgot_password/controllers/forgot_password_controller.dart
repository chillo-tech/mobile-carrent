import 'dart:convert';

import 'package:carrent/controllers/countries_controller.dart';
import 'package:carrent/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/error_controller.dart';

class ForgotPasswordController extends GetxController {
  ErrorController errorController = ErrorController();
  final RxBool isEmailSent = false.obs;
  final RxBool isLoading = false.obs;
  final RxString email = ''.obs;
  final RxString error = ''.obs;

  RxBool resetWithEmail = true.obs;
  RxBool resetWithPhone = false.obs;

  late TextEditingController emailInputController = TextEditingController();
  late TextEditingController phoneInputController = TextEditingController();

  late TextEditingController newPasswordInputController =
      TextEditingController();
  late TextEditingController newPasswordConfirmInputController =
      TextEditingController();

  CountriesController countriesController = Get.put(CountriesController());

  void sendEmailOrSms() async {
    AuthService authService = AuthService();
    try {
      Get.dialog(Center(
        child: CircularProgressIndicator(
          color: Get.theme.colorScheme.secondary,
        ),
      ));
      final String recipientChannel = resetWithEmail.value
          ? emailInputController.text
          : "+${countriesController.selectedCountry.value.phonecode}${phoneInputController.text}";

      await authService
          .sendResetPasswordEmailOrSms(recipientChannel)
          .then((value) {
        isEmailSent.value = true;
        Get.back();
        if (jsonDecode(value)['otp'].toString().toLowerCase() == 'ok') {
          Get.toNamed('/success', arguments: {
            'title': resetWithEmail.value ? 'Email envoyé' : 'SMS envoyé',
            'description': resetWithEmail.value
                ? 'Vérifiez votre email et ouvrez le lien que nous avons envoyé pour continuer'
                : 'Vérifiez votre téléphone et ouvrez le lien que nous avons envoyé pour continuer',
            'buttonTitle': 'Continuer',
            'route': '/confirm_otp',
            'operation_type': 'forgot_password'
          });
        } else {
          errorController.handleError(
              "Impossible d'enoyer le code de vérification. Veuillez réessayer");
        }
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }

  void validatePasscode(String otp) async {
    AuthService authService = AuthService();
    try {
      Get.dialog(Center(
        child: CircularProgressIndicator(
          color: Get.theme.colorScheme.secondary,
        ),
      ));
      final String recipientChannel = resetWithEmail.value
          ? emailInputController.text
          : "+${countriesController.selectedCountry.value.phonecode}${phoneInputController.text}";

      await authService
          .validateResetPasswordCode(
              recipientChannel: recipientChannel, otp: "123456")
          .then((value) {
        isEmailSent.value = true;
        Get.back();
        Get.toNamed("/enter_new_password");
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }

  void setUpNewPassword() async {
    AuthService authService = AuthService();
    try {
      Get.dialog(Center(
        child: CircularProgressIndicator(
          color: Get.theme.colorScheme.secondary,
        ),
      ));
      final String recipientChannel = resetWithEmail.value
          ? emailInputController.text
          : "+${countriesController.selectedCountry.value.phonecode}${phoneInputController.text}";
      var payload = {
        "email": recipientChannel,
        "password": newPasswordInputController.text,
      };

      await authService.setUpNewPassword(payload).then((value) {
        isEmailSent.value = true;
        Get.back();
        Get.toNamed('/success', arguments: {
          'title': 'Réinitialisation du mot de passe',
          'description': 'Votre mot de passe a été réinitialisé avec succès',
          'buttonTitle': 'Se connecter maintenant',
          'route': '/login'
        });
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }
}
