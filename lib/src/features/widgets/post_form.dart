import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../common/app_sizes.dart';
import '../../../../../common/common_fonctions.dart';
import '../../../../../helpers/assets.dart';
import '../../../../../theme/theme.dart';
import '../../../models/car_brand.dart';
import 'bottom_modal.dart';
import 'form_input_field.dart';
import 'primary_button.dart';

class PostForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController immatriculationController;
  final TextEditingController cityController;
  final TextEditingController yearController;
  final TextEditingController conditionController;
  final TextEditingController typeCarburantController;
  final TextEditingController numberOfPlacesController;
  final TextEditingController priceController;
  final TextEditingController phoneNumberProprietorController;
  final TextEditingController descriptionController;
  final RxString startAvailableDate;
  final RxString endAvailableDate;
  final RxList<XFile?> imageFiles;
  final Rx<XFile?> pickedFile;
  final RxBool hasErrorOnDocument;
  final RxBool hasErrorOnImages;
  RxBool isMakeBottomModalOpened;
  RxBool isModelBottomModalOpened;
  final Function() onSave;
  final Function() onCancel;
  final Function(String carBrand) loadCarModelsFromACar;
  final RxList<CarBrand> carBrands;
  final RxList<String> carModels;
  final RxList<String> carTypeCarbutant;
  final RxList<String> carCondition;
  RxBool isOnPageOpening;
  final bool isEditMode;
  final bool isUpdatePost;

  PostForm({
    required this.formKey,
    required this.makeController,
    required this.modelController,
    required this.immatriculationController,
    required this.cityController,
    required this.yearController,
    required this.conditionController,
    required this.typeCarburantController,
    required this.numberOfPlacesController,
    required this.priceController,
    required this.phoneNumberProprietorController,
    required this.descriptionController,
    required this.startAvailableDate,
    required this.endAvailableDate,
    required this.imageFiles,
    required this.pickedFile,
    required this.hasErrorOnDocument,
    required this.hasErrorOnImages,
    required this.isMakeBottomModalOpened,
    required this.isModelBottomModalOpened,
    required this.onSave,
    required this.onCancel,
    required this.loadCarModelsFromACar,
    required this.carBrands,
    required this.carModels,
    required this.carTypeCarbutant,
    required this.carCondition,
    required this.isOnPageOpening,
    this.isEditMode = false,
    this.isUpdatePost = false,
  });

  void _controlModal(List<String> elements,
      TextEditingController dropdownController, String label, bool isOpened) {
    if (label == 'Marque') {
      isMakeBottomModalOpened(!isMakeBottomModalOpened.value);
    } else {
      isModelBottomModalOpened(!isModelBottomModalOpened.value);
    }
    showModalBottomSheet(
      showDragHandle: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return BottomModal(
          searchList: elements,
          dropdownController: dropdownController,
          label: label,
        );
      },
    ).whenComplete(() {
      if (label == 'Marque') {
        isMakeBottomModalOpened(!isMakeBottomModalOpened.value);
      } else {
        isModelBottomModalOpened(!isModelBottomModalOpened.value);
      }

      CarBrand? selectedCarBrand = null;
      if (label == 'Marque' && dropdownController.text.isNotEmpty) {
        loadCarModelsFromACar(dropdownController.text);
        selectedCarBrand = carBrands
            .firstWhere((element) => element.brand == dropdownController.text);
      }
      if (selectedCarBrand != null &&
          !selectedCarBrand.models.contains(modelController.text)) {
        modelController.text = '';
      }
      // widget.onChanged(dropdownController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: onCancel,
          child: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: ColorStyle.textBlackColor,
            size: 20.0,
          ),
        ),
        title: Text(
          "Retour",
          style: GoogleFonts.lato(
            color: ColorStyle.textBlackColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    isEditMode ? "Modifier l'annonce" : "Créer une annonce",
                    style: GoogleFonts.lato(
                      color: ColorStyle.fontColorLight,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  gapH16,
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      List<XFile> files = (await picker.pickMultiImage());
                      if (files.isNotEmpty) {
                        imageFiles.value = files;
                      }
                      if (imageFiles.isNotEmpty) {
                        hasErrorOnImages(false);
                      }
                    },
                    child: isUpdatePost? Obx(() {
                    return imageFiles.isNotEmpty
                        ? Container(
                            height: 140.0,
                            decoration: BoxDecoration(
                              color: ColorStyle.containerBg,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: ListView.builder(
                                itemCount:
                                    imageFiles.length,
                                // itemCount: 3,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: (index ==
                                                (imageFiles.length -
                                                    1))
                                            ? 0.0
                                            : 10.0),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                child: Image.file(
                                                  File(imageFiles[index]!.path),
                                                  fit: BoxFit.cover,
                                                  // width: 120.0,
                                                )
                                                // child: Image.network(
                                                //   "https://files.mky-corp.fr/${post.imagePathCar![index]}",
                                                //   // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSECQOhDS2zlvsxpM4k6bhMedrbbVgDSiSEbA&s",
                                                //   fit: BoxFit.cover,
                                                //   width: 120.0,
                                                //   // width: double.infinity,
                                                // ),
                                                ),
                                            Positioned(
                                              top: 5.0,
                                              right: 5.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  imageFiles
                                                      .removeAt(index);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: ColorStyle.grey
                                                        .withOpacity(0.8),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    FontAwesomeIcons.times,
                                                    color: ColorStyle
                                                        .textBlackColor,
                                                    size: 16.0,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        if (index ==
                                            (imageFiles.length - 1))
                                          GestureDetector(
                                            onTap: () async {
                                              final ImagePicker picker =
                                                  ImagePicker();
                                              XFile? files =
                                                  (await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery));
                                              if (files != null) {
                                                imageFiles
                                                    .add(files);
                                              }
                                            },
                                            child: Container(
                                              // width: 120.0,
                                              margin:
                                                  EdgeInsets.only(left: 10.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20.0,
                                                      horizontal: 10.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  color:
                                                      ColorStyle.addPictureBg),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                      FontAwesomeIcons.camera,
                                                      color: ColorStyle.white,
                                                      size: 20.0),
                                                  const SizedBox(height: 10.0),
                                                  Text(
                                                    "Ajouter une image",
                                                    style: GoogleFonts.lato(
                                                      color: ColorStyle.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : GestureDetector(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              List<XFile> files =
                                  (await picker.pickMultiImage());
                              if (files.isNotEmpty) {
                                imageFiles.value = files;
                              }
                              if (imageFiles.isNotEmpty) {
                                hasErrorOnImages(false);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              // margin: EdgeInsets.only(left: 10.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: ColorStyle.addPictureBg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FontAwesomeIcons.camera,
                                      color: ColorStyle.white, size: 20.0),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Ajouter une image",
                                    style: GoogleFonts.lato(
                                      color: ColorStyle.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                  }): Obx(() {
                      return imageFiles.isNotEmpty &&
                              imageFiles[0]!.path.isNotEmpty
                          ? Container(
                              width: double.infinity,
                              height: 150.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(imageFiles[0]!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: ColorStyle.containerBg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FontAwesomeIcons.camera,
                                      color: ColorStyle.hintColor, size: 20.0),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Ajouter des photos",
                                    style: GoogleFonts.lato(
                                      color: ColorStyle.hintColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            );
                    }),
                  ),
                  gapH8,
                  Obx(() {
                    return hasErrorOnImages.value
                        ? Text(
                            "Selectionner au moins une image",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: ColorStyle.lightPrimaryColor),
                          )
                        : SizedBox();
                  }),
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      XFile? file = (await picker.pickMedia());
                      if (file != null) {
                        pickedFile.value = file;
                      }
                      if ((pickedFile.value != null &&
                          pickedFile.value?.name != null &&
                          pickedFile.value!.name.isNotEmpty)) {
                        hasErrorOnDocument(false);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: ColorStyle.hintColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            return Text(
                              pickedFile.value != null &&
                                      pickedFile.value?.name != null &&
                                      pickedFile.value!.name.isNotEmpty
                                  ? pickedFile.value!.name
                                  : 'Télécharger le document du véhicule',
                              style: GoogleFonts.lato(
                                color: ColorStyle.blackBackground,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }),
                          const SizedBox(width: 10.0),
                          SvgPicture.asset(
                            Assets.upload,
                            width: 18.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  gapH8,
                  Obx(() {
                    return hasErrorOnDocument.value
                        ? Text(
                            "Selectionner un document",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: ColorStyle.lightPrimaryColor),
                          )
                        : SizedBox();
                  }),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    onTap: () {
                      _controlModal(
                          carBrands.map((e) => e.brand).toList(),
                          makeController,
                          'Marque',
                          isMakeBottomModalOpened.value);
                    },
                    readOnly: true,
                    labelText: 'Marque',
                    placeholder: 'Entrez la marque du véhicule',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    controller: makeController,
                    suffixIcon: Obx(() {
                      return Icon(
                          isMakeBottomModalOpened
                                  .value // Replace with actual state
                              ? Icons.keyboard_arrow_up_sharp
                              : Icons.keyboard_arrow_down_sharp,
                          color: const Color(0xFF858381));
                    }),
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le modèle du véhicule';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    onTap: () {
                      _controlModal(
                          carModels.map((model) => model).toList(),
                          modelController,
                          'Modèle',
                          isModelBottomModalOpened.value);
                    },
                    readOnly: true,
                    labelText: 'Modèle',
                    placeholder: 'Entrez le modèle du véhicule',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    controller: modelController,
                    suffixIcon: Obx(() {
                      return Icon(
                          isModelBottomModalOpened.value
                              ? Icons.keyboard_arrow_up_sharp
                              : Icons.keyboard_arrow_down_sharp,
                          color: const Color(0xFF858381));
                    }),
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le modèle du véhicule';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Immatriculation',
                    placeholder: "Entrez l'immatriculation du véhicule",
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    controller: immatriculationController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer l'immatriculation du véhicule";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Ville',
                    placeholder: "Ville ou se trouve le vehicule",
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    controller: cityController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer la ville du véhicule";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Plage de dates de disponibilité',
                        style: GoogleFonts.lato(
                          color: ColorStyle.fontColorLight,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      gapH4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var initialDate = DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day + 1);
                              final DateTime? picked = await showDatePicker(
                                  fieldHintText: "Choisissez une date",
                                  locale: const Locale('fr'),
                                  fieldLabelText: "Date",
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: initialDate,
                                  lastDate: DateTime(2030));
                              if (picked != null) {
                                startAvailableDate(
                                    convertDate(picked.toString()));
                                DateTime startDate =
                                    parseDate(startAvailableDate.value);
                                DateTime endDate =
                                    parseDate(endAvailableDate.value);

                                // Vérifier que la date de début ne soit pas après la date de fin
                                if (startDate.isAfter(endDate)) {
                                  isOnPageOpening(false);
                                  startAvailableDate('');
                                  // ErrorController().showMessage(
                                  //     'La date de début ne peut pas être après la date de fin.');
                                } else {
                                  startAvailableDate(
                                      convertDate(picked.toString()));
                                }
                              }
                            },
                            child: Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width / 3.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: ColorStyle.containerBg,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(() {
                                    return Text(
                                      startAvailableDate.isNotEmpty
                                          ? startAvailableDate.value
                                          : 'JJ/MM/AAAA',
                                      style: GoogleFonts.lato(
                                        color: ColorStyle.hintColor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var initialDate = DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day + 1);
                              final DateTime? picked = await showDatePicker(
                                  fieldHintText: "Choisissez une date",
                                  locale: const Locale('fr'),
                                  fieldLabelText: "Date",
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: initialDate,
                                  lastDate: DateTime(2030));
                              if (picked != null) {
                                endAvailableDate(
                                    convertDate(picked.toString()));
                                DateTime startDate =
                                    parseDate(startAvailableDate.value);
                                DateTime endDate =
                                    parseDate(endAvailableDate.value);

                                // Vérifier que la date de fin ne soit pas avant la date de début
                                if (endDate.isBefore(startDate)) {
                                  isOnPageOpening(false);
                                  endAvailableDate('');
                                  // ErrorController().showMessage(
                                  //     'La date de fin ne peut pas être avant la date de début.');
                                } else {
                                  endAvailableDate(
                                      convertDate(picked.toString()));
                                }
                              }
                            },
                            child: Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width / 3.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: ColorStyle.containerBg,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(() {
                                    return Text(
                                      endAvailableDate.isNotEmpty
                                          ? endAvailableDate.value
                                          : 'JJ/MM/AAAA',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        color: ColorStyle.hintColor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width / 4.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: ColorStyle.containerBg,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  Assets.calendar,
                                  height: 14.0,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const Icon(
                                  FontAwesomeIcons.chevronDown,
                                  size: 12.0,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Obx(() {
                    return (startAvailableDate.isEmpty ||
                                endAvailableDate.isEmpty) &&
                            !isOnPageOpening.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Veuillez entrer une plage de dates valide",
                              style: GoogleFonts.lato(
                                color: ColorStyle.lightPrimaryColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : SizedBox();
                  }),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Année',
                    placeholder: "Entrez l'année d'achat du véhicule",
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.number,
                    controller: yearController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer l'année d'achat du véhicule";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Nombre de places',
                    placeholder: 'Entrez le nombre de places du véhicule',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.number,
                    controller: numberOfPlacesController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nombre de places du véhicule';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Prix par jour en FCFA',
                    placeholder:
                        'Entrez le prix de location journalier du véhicule',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.number,
                    controller: priceController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le prix de location journalier du véhicule';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Numéro de téléphone du propriétaire',
                    hasCountry: true,
                    placeholder: 'Entrez le numéro du propriétaire',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.phone,
                    controller: phoneNumberProprietorController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le numéro de téléphone du propriétaire';
                      }
                      if (value.contains('+')) {
                        return 'Veuillez entrer votre téléphone sans indicatif';
                      }
                      if (value.contains(' ')) {
                        return 'Veuillez entrer votre téléphone sans les espaces';
                      }
                      if (value.startsWith("+") ||
                          value.startsWith("00") ||
                          value.startsWith("+00")) {
                        return 'Veuillez entrer votre téléphone sans indicatif';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  // Text(
                  //   'Évaluez l\'état du véhicule de 1 à 10',
                  //   style: GoogleFonts.lato(
                  //     color: ColorStyle.fontColorLight,
                  //     fontSize: 16.0,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                  // gapH4,
                  FormInputField(
                    onTap: () {
                      _controlModal(
                          carCondition.map((model) => model).toList(),
                          conditionController,
                          'Etat du véhicule',
                          isModelBottomModalOpened.value);
                    },
                    readOnly: true,
                    labelText: 'Évaluez l\'état du véhicule de 1 à 10',
                    placeholder: 'Sélectionnez une note',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    controller: conditionController,
                    suffixIcon: Obx(() {
                      return Icon(
                          isModelBottomModalOpened.value
                              ? Icons.keyboard_arrow_up_sharp
                              : Icons.keyboard_arrow_down_sharp,
                          color: const Color(0xFF858381));
                    }),
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner une note';
                      }
                      return null;
                    },
                  ),
                  // DropdownButtonFormField(
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Veuillez sélectionner une note';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: ColorStyle.bgFieldGrey,
                  //     labelText: 'Sélectionnez une note',
                  //     labelStyle: GoogleFonts.lato(
                  //       color: ColorStyle.hintColor,
                  //       fontSize: 15.0,
                  //       fontWeight: FontWeight.w300,
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8.0),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  //   items: carCondition
                  //       .map((e) => DropdownMenuItem(
                  //             value: e,
                  //             child: Text(e),
                  //           ))
                  //       .toList(),
                  //   onChanged: (value) {
                  //     conditionController.text = value.toString();
                  //   },
                  // ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    onTap: () {
                      _controlModal(
                          carTypeCarbutant.map((model) => model).toList(),
                          typeCarburantController,
                          'Type de carburant',
                          isModelBottomModalOpened.value);
                    },
                    readOnly: true,
                    labelText: 'Type de carburant',
                    placeholder: 'Sélectionnez le type de carburant',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    controller: typeCarburantController,
                    suffixIcon: Obx(() {
                      return Icon(
                          isModelBottomModalOpened.value
                              ? Icons.keyboard_arrow_up_sharp
                              : Icons.keyboard_arrow_down_sharp,
                          color: const Color(0xFF858381));
                    }),
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner le type de carburant';
                      }
                      return null;
                    },
                  ),
                  // Text(
                  //   'Type de carburant',
                  //   style: GoogleFonts.lato(
                  //     color: ColorStyle.fontColorLight,
                  //     fontSize: 16.0,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                  // gapH4,
                  // DropdownButtonFormField(
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Veuillez sélectionner le type de carburant';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: ColorStyle.bgFieldGrey,
                  //     labelText: 'Sélectionnez le type de carburant',
                  //     labelStyle: GoogleFonts.lato(
                  //       color: ColorStyle.hintColor,
                  //       fontSize: 15.0,
                  //       fontWeight: FontWeight.w300,
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8.0),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  //   items: carTypeCarbutant
                  //       .map((e) => DropdownMenuItem(
                  //             value: e,
                  //             child: Text(e),
                  //           ))
                  //       .toList(),
                  //   onChanged: (value) {
                  //     typeCarburantController.text = value.toString();
                  //   },
                  // ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Description (optionnel)',
                    placeholder: 'Entrez une brève description du véhicule',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    maxLines: 3,
                    textInputType: TextInputType.text,
                    controller: descriptionController,
                  ),
                  const SizedBox(height: 70.0),
                  PrimaryButton(
                      title:
                          isEditMode ? 'Enregistrer la mise à jour' : 'Créer',
                      onPressed: onSave),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
