import 'package:bot_toast/bot_toast.dart';
import '../../../../controllers/error_controller.dart';
import '../../../../models/car_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../common/storage_constants.dart';
import '../../../../services/car.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../create_post/controllers/post_controller.dart';

class HomeController extends GetxController {
  RxString refresh_token = ''.obs;
  RxInt selectedIndex = 0.obs;
  final ErrorController errorController = ErrorController();
  RxList<CarResponse> cars = RxList();

  final PostController postController =
      Get.put(PostController(launchInitState: false));
  final BookingsController bookingsController =
      Get.put(BookingsController(launchInitState: false));

  void onTabItemTapped(int index) {
    selectedIndex(index);
  }

  void logoutUser(String logoutMessage) async {
    var isLoggedIn = GetStorage().read(StorageConstants.loggedIn);
    isLoggedIn = isLoggedIn != null ? isLoggedIn : false;
    if (isLoggedIn) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
      GetStorage().write('lastLoginTime', formattedDate);
      GetStorage().remove(StorageConstants.loggedIn);
      // GetStorage().remove(StorageConstants.pushNotification);
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

  Future<void> getCars() async {
    // Get.dialog(Center(
    //   child: CircularProgressIndicator(
    //     color: Get.theme.colorScheme.secondary,
    //   ),
    // ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    CarService carService = CarService();

    try {
      // Check if login details are correct by authenticating

      await carService.getCars().then((response) async {
        cars.value = response;
        print("---------------------");
        print(response);
        // Get.back();
      });
    } catch (error) {
      // Get.back();
      errorController.handleError(error);
    }
  }

  Future<void> loadData() async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    await getCars();
    final loggedIn = GetStorage().read(StorageConstants.loggedIn);
    if (loggedIn != null && loggedIn) {
      await postController.getMyPosts(launchLoader: false);
      await bookingsController.getMyBookings(launchLoader: false);
    }
    Get.back();
  }
}
