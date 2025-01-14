import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../models/car_response.dart';

import '../../../../common/storage_constants.dart';
import '../../../../controllers/error_controller.dart';
import '../../../../env.dart';
import '../../../../models/post_response.dart';
import '../../../../network/auth_headers.dart';
import '../../../../theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../../helpers/assets.dart';
import '../../../../services/post.dart';
import '../../../../controllers/countries_controller.dart';

class PostController extends GetxController {
  bool launchInitState = true;
  PostController({this.launchInitState = true});

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

  Future<void> getMyPosts({required bool launchLoader}) async {
    if (launchLoader) {
      Get.dialog(Center(
        child: CircularProgressIndicator(
          color: Get.theme.colorScheme.secondary,
        ),
      ));
    }
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    PostService postService = PostService();

    try {
      // Check if login details are correct by authenticating

      await postService.getMyPosts().then((response) async {
        myCars.value = response;
        print("---------------------");
        print(response);
        if (launchLoader) {
          Get.back();
        }
      });
    } catch (error) {
      if (launchLoader) {
        Get.back();
      }
      errorController.handleError(error);
    }
  }

  void getPost() {
    var rawPosts = GetStorage().read('posts') as List<dynamic>?;
    if (rawPosts != null) {
      if (rawPosts.isNotEmpty && rawPosts.runtimeType == RxList<PostResponse>) {
        posts.value = rawPosts as List<PostResponse>;
      } else {
        posts.value = rawPosts.map((post) {
          print(post);
          return PostResponse.fromJson(post);
        }).toList();
      }
    }
  }

  void createPost() async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    PostService postService = PostService();

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse(Env.getUserManagementApiBaseUrl() + 'cars'));

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
      request.fields['startDisponibilityDate'] = startAvailableDate.value;
      request.fields['endDisponibilityDate'] = endAvailableDate.value;
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
          'title': 'Votre publication a été créée avec succès ✨',
          'description':
              "Un administrateur de Carrent examinera votre annonce avant qu'elle ne soit publiée. Vous serez immédiatement notifié.",
          'buttonTitle': 'Continuer',
          'route': '/bottom_nav'
        });
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }

  void editPost() async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    // Utility.showLoader("${'logging_in'.tr}", "${'we_check_your_login'.tr}...");
    PostService postService = PostService();

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse(Env.getUserManagementApiBaseUrl() + 'cars'));

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
      request.fields['startDisponibilityDate'] = startAvailableDate.value;
      request.fields['endDisponibilityDate'] = endAvailableDate.value;
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
          'title': 'Votre publication a été créée avec succès ✨',
          'description':
              "Un administrateur de Carrent examinera votre annonce avant qu'elle ne soit publiée. Vous serez immédiatement notifié.",
          'buttonTitle': 'Continuer',
          'route': '/bottom_nav'
        });
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }

  // TODO: review this implementation
  Future<void> downloadFile(CarResponse currentPost) async {
    try {
      Get.dialog(Center(
        child: CircularProgressIndicator(
          color: Get.theme.colorScheme.secondary,
        ),
      ));

      Directory? directory;
      final String fileUrl =
          "https://files.chillo.fr/${currentPost.imagePathDocument}";

      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception("Permission d'accès au stockage refusée.");
      }

      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
        if (directory == null || !await directory.exists()) {
          throw Exception("Impossible d'accéder au répertoire de stockage.");
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        throw Exception("Plateforme non prise en charge.");
      }

      final response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode == 200) {
        final fileName = cleanFileName(
            '${currentPost.make}_${currentPost.model}.${fileUrl.split('.').last}');
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        errorController
            .showMessage("Fichier téléchargé avec succès : $filePath");
        Get.back();
      } else {
        Get.back();
        errorController.handleError("Échec du téléchargement. Reessayez");
      }
    } catch (e) {
      Get.back();
      errorController.handleError("Erreur : ${e.toString()}");
    }
  }

  String cleanFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[^\w\.\-]'), '_');
  }


  Future<void> deleteMyPost(String currentPostId) async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: Get.theme.colorScheme.secondary,
      ),
    ));
    PostService postService = PostService();

    posts.removeWhere((element) => element.id == currentPostId);
    print(posts);

    try {
      await postService.deleteMyPost(currentPostId).then((response) async {
        // myCars.value = response;
        if (response.contains("was deleted")) {
          posts.removeWhere((element) => element.id == currentPostId);
          print("---------------------");
          print(response);

          errorController.showMessage("Le vehicule supprime avec succes");
        } else {
          errorController
              .showMessage("Le vehicule n'a pas ete supprime, ressayer.");
        }
        Get.back();
        Get.offAllNamed('/bottom_nav');
      });
    } catch (error) {
      Get.back();
      errorController.handleError(error);
    }
  }
}
