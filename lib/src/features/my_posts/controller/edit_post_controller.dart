import 'dart:io';

import 'package:carrent/common/common_fonctions.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../helpers/country_helper.dart';
import '../../../../models/car_response.dart';

import '../../../../common/storage_constants.dart';
import '../../../../controllers/error_controller.dart';
import '../../../../env.dart';
import '../../../../models/post_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../../helpers/assets.dart';
import '../../../../services/post.dart';
import '../../../../controllers/countries_controller.dart';

class EditPostController extends GetxController {
  ErrorController errorController = ErrorController();

  final Rx<XFile?> imageFile = XFile('').obs;
  final Rx<XFile?> pickedFile = XFile('').obs;
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController typeCarburantController = TextEditingController();
  final TextEditingController numberOfPlacesController =
      TextEditingController();
  final TextEditingController imagePathCarController = TextEditingController();
  final TextEditingController imagePathDocumentController =
      TextEditingController();
  final TextEditingController phoneNumberProprietorController =
      TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxString startAvailableDate = ''.obs;
  final RxString endAvailableDate = ''.obs;
  RxList<XFile?> imageFiles = RxList();
  RxBool hasErrorOnDocument = false.obs;
  RxList<CarResponse> myCars = (List<CarResponse>.of([])).obs;

  RxList<PostResponse> posts = (List<PostResponse>.of([])).obs;
  List<String> carList = [
    Assets.car1,
    Assets.car2,
    Assets.car3,
    Assets.car4,
  ];
  CountriesController countriesController = Get.put(CountriesController());

  CarResponse currentPost = Get.arguments;

  @override
  onInit() {
    assignValues();
    super.onInit();
  }

  void assignValues() async {
    makeController.text = currentPost.make;
    modelController.text = currentPost.model;
    yearController.text = currentPost.year!;
    conditionController.text = currentPost.condition!;
    typeCarburantController.text = currentPost.typeCarburant!;
    numberOfPlacesController.text = currentPost.numberOfPlaces.toString();
    // imagePathCarController.text = currentPost.imagePathCar!;
    // imagePathDocumentController.text = currentPost.imagePathDocument!;
    PhoneNumber? propriorPhoneNumber =
        await extractCountryCode(currentPost.phoneNumberProprietor!);
    phoneNumberProprietorController.text = propriorPhoneNumber?.phoneNumber
            ?.split(propriorPhoneNumber.dialCode!)
            .last ??
        "";
    countriesController.selectedCountry.value =
        countriesController.countriesResponse.firstWhere((country) =>
            country.phonecode ==
            int.parse(propriorPhoneNumber?.dialCode ??
                CountryHelper.PHONE_CODE.toString()));

    priceController.text = currentPost.price!;
    descriptionController.text = currentPost.description ?? '';
    startAvailableDate.value =
        convertDateToDayMonthYear(currentPost.startDisponibilityDate!);
    endAvailableDate.value =
        convertDateToDayMonthYear(currentPost.endDisponibilityDate!);

    Future.delayed(Duration(seconds: 0), () {
      retreiveFiles();
    });
  }

  Future<void> retreiveFiles() async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));

    currentPost.imagePathCar?.forEach((element) async {
      imageFiles.add(XFile(
          await urlToFile("https://files.chillo.fr/$element").then((file) {
        print(file.path);
        return file.path;
      })));
    });

    pickedFile(XFile(await urlToFile(
            "https://files.chillo.fr/${currentPost.imagePathDocument}")
        .then((file) {
      print(file.path);
      return file.path;
    })));
    Get.back();
  }

  Future<PhoneNumber?> extractCountryCode(String phoneNumber) async {
    try {
      final parsed =
          await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
      print(parsed);

      // return parsed.phoneNumber!.split(parsed.dialCode!).last;
      return parsed;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File> urlToFile(String imageUrl) async {
    // Télécharge l'image depuis l'URL
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Obtient le répertoire temporaire
      final directory = await getTemporaryDirectory();

      // Crée un fichier dans ce répertoire
      final filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);

      // Écrit les données de l'image dans le fichier
      await file.writeAsBytes(response.bodyBytes);

      return file;
    } else {
      throw Exception('Échec du téléchargement de l\'image');
    }
  }

  void editPost() async {
    print(imageFiles[0]?.path);
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    PostService postService = PostService();

    try {
      var request = http.MultipartRequest(
          'PUT',
          Uri.parse(
              '${Env.getUserManagementApiBaseUrl()}cars/${currentPost.id}'));

      request.fields['make'] = makeController.text;
      request.fields['model'] = modelController.text;
      request.fields['year'] = yearController.text;
      request.fields['condition'] = conditionController.text;
      request.fields['typeCarburant'] = typeCarburantController.text;
      request.fields['numberOfPlaces'] = numberOfPlacesController.text;
      // request.fields['imagePathCar'] = imagePathCarController.text;
      // request.fields['imagePathDocument'] = imagePathDocumentController.text;
      request.fields['phoneNumberProprietor'] =
          '+${countriesController.selectedCountry.value.phonecode}${phoneNumberProprietorController.text}';
      request.fields['description'] = descriptionController.text;
      request.fields['startDisponibilityDate'] =
          "${startAvailableDate.value} 00:00";
      request.fields['endDisponibilityDate'] =
          "${endAvailableDate.value} 00:00";
      // request.fields['price'] = priceController.text;
      // request.fields['price'] = priceController.text;
      request.fields['price'] = priceController.text;
      request.fields['price'] = priceController.text;

      imageFiles.forEach(
        (element) async {
          request.files.add(
            await http.MultipartFile.fromPath(
              'imagesfile',
              element!.path,
            ),
          );
        },
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'documentfile',
          pickedFile.value!.path,
        ),
      );

      print("FIELDS: ${request.fields}");
      print("FILES: ${request.files}");

      String token = await GetStorage().read(StorageConstants.refreshToken);
      request.headers.putIfAbsent("Authorization", () => 'Bearer $token');
      // Login request object
      // var requestObject = {
      //   "make": makeController.text,
      //   "model": modelController.text,
      //   "year": yearController.text,
      //   "condition": conditionController.text,
      //   "typeCarburant": typeCarburantController.text,
      //   "numberOfPlaces": numberOfPlacesController.text,
      //   "imagePathCar": imagePathCarController.text,
      //   "imagePathDocument": imagePathDocumentController.text,
      //   "phoneNumberProprietor":
      //       '+${countriesController.selectedCountry.value.phonecode}${phoneNumberProprietorController.text}'
      // };
      // Check if login details are correct by authenticating

      await postService.createOrEditPost(request).then((response) async {
        print('response');
        print(response.toJson());
        carList.shuffle();
        // response.imagePathCar = carList.first;
        // response.description = descriptionController.text;
        // posts.add(response);
        myCars.add(response);
        print("*---------**********-------------");
        print(myCars);
        await GetStorage().write('posts', posts);
        Get.back();
        Get.offAllNamed('/success_post', arguments: {
          'image': Assets.success_post,
          'title': 'Votre publication a été modifiée avec succès ✨',
          'description':
              "Un administrateur de Carrent examinera votre annonce avant qu'elle ne soit republiée. Vous serez immédiatement notifié.",
          'buttonTitle': 'Continuer',
          'route': '/bottom_nav'
        });
      });
    } catch (error) {
      print(error);
      Get.back();
      errorController.handleError(error);
    }
  }
}
