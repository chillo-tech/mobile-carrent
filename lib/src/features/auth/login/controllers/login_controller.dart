import '../../../../../controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

import '../../../../../common/storage_constants.dart';
import '../../../../../models/login_response.dart';
import '../../../../../services/auth.dart';
import '../../../../../utils/utility.dart';
import '../../../../../controllers/countries_controller.dart';
import '../../../../../controllers/error_controller.dart';
import '../../../../../controllers/toast_controller.dart';

class LoginController extends GetxController {
  final log = Logger('LoginController');

  late ToastController toastController;
  ErrorController errorController = ErrorController();
  var isLoading = false.obs;
  RxBool loginWithEmail = true.obs;
  RxBool loginWithPhone = false.obs;

  late TextEditingController loginEmailTextController = TextEditingController();
  late TextEditingController loginPasswordTextController =
      TextEditingController();
  var biometricAvailable = false.obs;
  RxList<Map<String, dynamic>> biometricOptions = RxList();
  final UserController _userController = Get.put(UserController());
  var lastLoggedInUser = "".obs;
  var phoneCode = "".obs;

  var isLoggedIn = GetStorage().read(StorageConstants.loggedIn);

  CountriesController countriesController = Get.put(CountriesController());

  Rx<String?> firebaseToken = ''.obs;

  var userDeviceId = ''.obs;
  var userDeviceDescription = ''.obs;
  var oldUserDeviceId = ''.obs;

  var appVersion = "".obs;

  // Update password controllers
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onInit() async {
    countriesController.fetchSaraAvailableCountries();

    super.onInit();
  }

  void authenticate() async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    AuthService authService = AuthService();

    try {
      // Login request object
      var requestObject = {
        "email": loginEmailTextController.text,
        "password": loginPasswordTextController.text,
      };
      if (loginWithPhone.value) {
        requestObject = {
          "email":
              '+${countriesController.selectedCountry.value.phonecode}${loginEmailTextController.text}',
          "password": loginPasswordTextController.text,
        };
      }
      // Check if login details are correct by authenticating

      await authService.login(requestObject).then((response) async {
        print("---------------------");
        print(response);
        if (response != null &&
            response.user.id != null &&
            response.user.id.isNotEmpty) {
          await _userController.saveUserData(response);
          Get.back();

          GetStorage().write(StorageConstants.refreshToken, response.token);
          GetStorage().write(StorageConstants.loggedIn, true);
          Get.offAllNamed('/bottom_nav');
        }
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }

  // @override
  // void onClose() {
  //   print("onClose called");

  //   loginEmailTextController.dispose();
  //   loginPasswordTextController.dispose();
  //   super.onClose();
  // }
}
