import 'package:get_storage/get_storage.dart';

import '../../../../common/common_fonctions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/storage_constants.dart';
import '../../../../controllers/error_controller.dart';
import '../../../../helpers/assets.dart';
import 'package:get/get.dart';

import '../../../../models/car_response.dart';
import '../../../../services/review.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/utility.dart';
import 'home_controller.dart';

class CarDetailsController extends GetxController {
  // final CarRepository _carRepository = Get.find<CarRepository>();
  final CarResponse carResponse;
  // final RxBool isFavorite = false.obs;

  CarDetailsController({required this.carResponse});

  // @override
  // void onInit() {
  //   super.onInit();
  //   isFavorite.value = _carRepository.isFavorite(car);
  // }

  // void toggleFavorite() {
  //   isFavorite.value = _carRepository.toggleFavorite(car);
  // }'
  // final CarResponse carResponse = Get.arguments;

  final ErrorController errorController = ErrorController();
  List<Map<String, String>> carDetailsItems = [];
  List<Map<String, dynamic>> actions = [];
  TextEditingController reviewController = TextEditingController();
  RxInt rating = 0.obs;

  final HomeController homeController = Get.put(HomeController());

  RxList<CarResponse> cars = (List<CarResponse>.of([])).obs;
  RxList<Review> reviews = (List<Review>.of([])).obs;

  TextEditingController conflictDescription = TextEditingController();
  @override
  void onInit() {
    carDetailsItems = [
      {
        'title': convertDateToPlainString(carResponse.startDisponibilityDate!),
        'description':
            convertDateToPlainString(carResponse.endDisponibilityDate!),
        'icon': Assets.calendar_details,
      },
      {
        'title': carResponse.year!,
        'description': carResponse.typeCarburant ?? "Super",
        'icon': Assets.about_grey,
      },
      {
        'title': '${carResponse.price} FCFA par jour',
        'icon': Assets.cash,
      },
    ];

    actions = [
      {
        'icon': Assets.white_car,
        'title': 'Retrait',
        'color': ColorStyle.lightPrimaryColor,
        'textColor': ColorStyle.lightWhiteBackground,
        'action': 'booking_withdraw',
      },
      {
        'icon': Assets.report,
        'title': 'Signaler un litige',
        'color': ColorStyle.lightGreyColor1,
        'textColor': ColorStyle.fontColorLight,
        'action': 'report_conflict',
      },
      {
        'icon': Assets.trash,
        'title': 'Annuler la réservation',
        'color': ColorStyle.lightGreyColor1,
        'textColor': ColorStyle.lightAccentColor,
        'action': 'cancel_booking',
      },
    ];

    rating = 0.obs;
    cars.value = List.from(homeController.cars);
    // final loggedIn = GetStorage().read(StorageConstants.loggedIn);
    // if (loggedIn != null && loggedIn) {
    Future.delayed(Duration(seconds: 0), () {
      cars.removeWhere((car) {
        return carResponse.id == car.id;
      });
      getPostReviews();
    });
    // }
    super.onInit();
  }

  getPostReviews({bool launchLoaders = true}) async {
    if (launchLoaders) {
      Get.dialog(Center(
        child: CircularProgressIndicator(
          color: Get.theme.colorScheme.secondary,
        ),
      ));
    }
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    ReviewService reviewService = ReviewService();

    try {
      // Check if login details are correct by authenticating

      await reviewService.getPostReviews(carResponse.id).then((response) async {
        // myCars.value = response;
        print("---------------------");
        print(response);
        reviews.addAll(response);
        reviews.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
        print("----------r-----------");
        print(reviews);
        if (launchLoaders) {
          Get.back();
        }
      });
    } catch (error) {
      Get.back();
      errorController.showMessage('Erreur lors de la récupération des avis');
      // errorController.handleError(error);
    }
  }

  void reviewAPost() async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    ReviewService reviewService = ReviewService();

    try {
      Review review = Review(
        review: reviewController.text,
        rating: rating.value + 1,
      );
      // Check if login details are correct by authenticating
      await reviewService
          .reviewPost(review, carResponse.id)
          .then((response) async {
        await getPostReviews(launchLoaders: false);
        reviewController = TextEditingController();
        // myCars.value = response;
        print("---------------------");
        print(response);
        Get.back();
      });
    } catch (error) {
      Get.back();
      errorController.handleError("Erreur lors de l'envoi de l'avis");
      // errorController.handleError(error);
    }
  }

  String formatTimeAgo(String notificationDate) {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy HH:mm");
    DateTime parsedDate = inputFormat.parse(notificationDate);
    DateTime now = DateTime.now();
    Duration difference = now.difference(parsedDate);

    if (difference.inSeconds < 60) {
      return "il y a ${difference.inSeconds} seconde${difference.inSeconds > 1 ? 's' : ''}";
    } else if (difference.inMinutes < 60) {
      return "il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}";
    } else if (difference.inHours < 24) {
      return "il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}";
    } else if (difference.inDays < 30) {
      return "il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}";
    } else if (difference.inDays > 30) {
      return "il y a ${(difference.inDays / 30).round()} mois";
    } else {
      // Pour les dates plus anciennes, afficher la date formatée
      DateFormat outputFormat = DateFormat("dd MMM yyyy à HH:mm");
      return "le ${outputFormat.format(parsedDate)}";
    }
  }
}
