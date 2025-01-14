import 'package:carrent/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/storage_constants.dart';
import '../../../../controllers/error_controller.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../env.dart';
import '../../../../helpers/assets.dart';
import '../../../../services/user.dart';
import '../../../../utils/utility.dart';
import 'package:http/http.dart' as http;

class UpdateProfileController extends GetxController {
  TextEditingController fullNameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final UserController _userController = Get.put(UserController());

  ErrorController errorController = ErrorController();
  FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

  void updateUserprofile() async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    UserService userService = UserService();

    try {
      String id =
          await flutterSecureStorage.read(key: StorageConstants.id) ?? '';

      // Update user request object
      http.MultipartRequest request = http.MultipartRequest('PUT',
          Uri.parse(Env.getUserManagementApiBaseUrl() + 'user/update/$id'));
      request.fields['completeName'] = fullNameTextController.text;
      if (_userController.currentuser != null &&
          (_userController.currentuser?.phoneNumber == null ||
          _userController.currentuser!.phoneNumber.isEmpty) &&
          phoneTextController.text.isNotEmpty) {
        request.fields['phoneNumber'] = phoneTextController.text;
      }
      if (_userController.currentuser != null &&
          (_userController.currentuser?.email == null ||
          _userController.currentuser!.email!.isEmpty) &&
          emailTextController.text.isNotEmpty) {
        request.fields['email'] = emailTextController.text;
      }

      String token = await GetStorage().read(StorageConstants.refreshToken);
      request.headers.putIfAbsent("Authorization", () => 'Bearer $token');
      // Check if login details are correct by authenticating
      await userService.updateUserprofile(request).then((response) async {
        print("---------------------");
        print(response);
        LoginResponse loginResponse = LoginResponse(user: response, token: '');
        await _userController.saveUserData(loginResponse);
        _userController.currentuser = response;
        Get.back();

        Get.toNamed('/success_post', arguments: {
          'image': Assets.success_withdraw,
          'title': "Mise a jour du profile",
          'description': "Votre profile a été mis a jour avec succes",
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
