import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:get_storage/get_storage.dart';

// import '../common/storage_constants.dart';
import '../common/storage_constants.dart';
import 'error_controller.dart';

class SplashController extends GetxController {

  ErrorController errorController = ErrorController();

  @override
  void onInit() async {
    startTime();

    super.onInit();
  }

  startTime() async {
    return Timer(const Duration(milliseconds: 3600), routeUser);
  }

  void routeUser() async {
    final loggedIn = GetStorage().read(StorageConstants.loggedIn);
    Get.offAllNamed(loggedIn != null && loggedIn ? '/home' : '/login');

  }

  @override
  void onClose() {
    super.onClose();
  }
}