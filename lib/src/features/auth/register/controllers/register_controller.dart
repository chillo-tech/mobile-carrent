import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

import '../../../../../common/storage_constants.dart';
import '../../../../../controllers/countries_controller.dart';
import '../../../../../controllers/error_controller.dart';
import '../../../../../controllers/toast_controller.dart';
import '../../../../../services/auth.dart';

class RegisterController extends GetxController {
  final log = Logger('LoginController');

  late ToastController toastController;
  ErrorController errorController = ErrorController();

  TextEditingController fullNameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  var biometricAvailable = false.obs;
  RxList<Map<String, dynamic>> biometricOptions = RxList();
  // FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
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

  void createAccount() async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    AuthService authService = AuthService();

    try {
      // Register request object
      var requestObject = {
        "firstName": fullNameTextController.text.split(' ').length >= 2
            ? fullNameTextController.text.split(' ')[0]
            : fullNameTextController.text,
        "lastName": fullNameTextController.text.split(' ').length >= 2
            ? fullNameTextController.text.split(' ')[1]
            : fullNameTextController.text,
        "email": emailTextController.text.isNotEmpty
            ? emailTextController.text
            : null,
        // "${fullNameTextController.text.split(' ').length >= 2 ? fullNameTextController.text.split(' ')[0] : fullNameTextController.text}@omail.com",
        "password": passwordTextController.text,
        "phoneNumber":
            '+${countriesController.selectedCountry.value.phonecode}${phoneTextController.text}',
      };
      print(requestObject);
      // Check if login details are correct by authenticating
      await authService.register(requestObject).then((response) async {
        print("---------------------");
        print(response);
        Get.back();

        Get.toNamed('/confirm_otp', arguments: {'operationType': 'register'});
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }

  void activateUser(String otp) async {
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
        "otp": "123456" // otp,
      };
      // Check if login details are correct by authenticating
      await authService.activate(requestObject).then((response) async {
        print("---------------------");
        print(response);
        Get.back();

        Get.offAllNamed('/login');
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }

  // @override
  // void onClose() {
  //   print("onClose called");
  //   fullNameTextController.dispose();
  //   phoneTextController.dispose();
  //   emailTextController.dispose();
  //   passwordTextController.dispose();
  //   super.onClose();
  // }
}
