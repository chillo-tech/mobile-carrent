import 'dart:io';

import '../../../../common/app_sizes.dart';
import '../../../../common/common_fonctions.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/post_controller.dart';
import '../../../../helpers/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../theme/theme.dart';
import '../../widgets/form_input_field.dart';
import '../../widgets/primary_button.dart';

class CreatePost extends StatelessWidget {
  CreatePost({super.key});
  final PostController _postcontroller = Get.put(PostController());
  final _formKey = GlobalKey<FormState>();

  List<String> vehicleRate = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  List<String> fuelType = [
    'Super',
    'Gazoil',
    'Électrique',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            _postcontroller.imageFile.value = XFile('');
            _postcontroller.pickedFile.value = XFile('');
            Get.back();
          },
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
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Créer une Annonce",
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
                        _postcontroller.imageFiles.value = files;
                      }
                    },
                    child: Obx(() {
                      return _postcontroller.imageFiles.isNotEmpty &&
                              _postcontroller.imageFiles[0]!.path.isNotEmpty
                          ? Container(
                              width: double.infinity,
                              height: 150.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(_postcontroller.imageFiles[0]!.path),
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
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      XFile? file = (await picker.pickMedia());
                      if (file != null) {
                        _postcontroller.pickedFile.value = file;
                      }
                      if ((_postcontroller.pickedFile.value != null &&
                          _postcontroller.pickedFile.value?.name != null &&
                          _postcontroller.pickedFile.value!.name.isNotEmpty)) {
                        _postcontroller.hasErrorOnDocument(false);
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
                              _postcontroller.pickedFile.value != null &&
                                      _postcontroller.pickedFile.value?.name !=
                                          null &&
                                      _postcontroller
                                          .pickedFile.value!.name.isNotEmpty
                                  ? _postcontroller.pickedFile.value!.name
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
                    return _postcontroller.hasErrorOnDocument.value
                        ? Text(
                            "Select a document",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: ColorStyle.lightPrimaryColor),
                          )
                        : SizedBox();
                  }),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Marque',
                    placeholder: 'Entrez la marque du véhicule',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    controller: _postcontroller.makeController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la marque du véhicule';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Modèle',
                    placeholder: 'Entrez le modèle du véhicule',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    controller: _postcontroller.modelController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le modèle du véhicule';
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                  fieldHintText: "Choisissez une date",
                                  locale: const Locale('fr'),
                                  fieldLabelText: "Date",
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030));
                              print(picked);
                              if (picked != null &&
                                  picked.toString() !=
                                      _postcontroller
                                          .startAvailableDate.value) {
                                _postcontroller.startAvailableDate(
                                    convertDate(picked.toString()));
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
                                      _postcontroller
                                              .startAvailableDate.isNotEmpty
                                          ? _postcontroller
                                              .startAvailableDate.value
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
                              final DateTime? picked = await showDatePicker(
                                  fieldHintText: "Choisissez une date",
                                  locale: const Locale('fr'),
                                  fieldLabelText: "Date",
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030));
                              print(picked);
                              if (picked != null &&
                                  picked.toString() !=
                                      _postcontroller.endAvailableDate.value) {
                                _postcontroller.endAvailableDate(
                                    convertDate(picked.toString()));
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
                                      _postcontroller
                                              .endAvailableDate.isNotEmpty
                                          ? (_postcontroller
                                              .endAvailableDate.value)
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
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Année',
                    placeholder: "Entrez l'année d'achat du véhicule",
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.number,
                    controller: _postcontroller.yearController,
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
                    controller: _postcontroller.numberOfPlacesController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nombre de places du véhicule';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Prix par jour en GBP',
                    placeholder:
                        'Entrez le prix de location journalier du véhicule',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.number,
                    controller: _postcontroller.priceController,
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
                    controller: _postcontroller.phoneNumberProprietorController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le numéro de téléphone du propriétaire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    'Évaluez l\'état du véhicule de 1 à 10',
                    style: GoogleFonts.lato(
                      color: ColorStyle.fontColorLight,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner une note';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorStyle.bgFieldGrey,
                      labelText: 'Sélectionnez une note',
                      labelStyle: GoogleFonts.lato(
                        color: ColorStyle.hintColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: vehicleRate
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      _postcontroller.conditionController.text =
                          value.toString();
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    'Type de carburant',
                    style: GoogleFonts.lato(
                      color: ColorStyle.fontColorLight,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner le type de carburant';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorStyle.bgFieldGrey,
                      labelText: 'Sélectionnez le type de carburant',
                      labelStyle: GoogleFonts.lato(
                        color: ColorStyle.hintColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: fuelType
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      _postcontroller.typeCarburantController.text =
                          value.toString();
                    },
                  ),
                  const SizedBox(height: 15.0),
                  FormInputField(
                    labelText: 'Description (optionnel)',
                    placeholder: 'Entrez une brève description du véhicule',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    maxLines: 3,
                    textInputType: TextInputType.text,
                    controller: _postcontroller.descriptionController,
                    // fieldValidator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter the daily rental price of the vehicle';
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 70.0),
                  PrimaryButton(
                      title: 'Créer',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (!(_postcontroller.pickedFile.value != null &&
                              _postcontroller.pickedFile.value?.name != null &&
                              _postcontroller
                                  .pickedFile.value!.name.isNotEmpty)) {
                            _postcontroller.hasErrorOnDocument(true);
                            return;
                          }
                          _postcontroller.createPost();
                        }
                        // Get.offNamed('/success_post');
                      }),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.lato(
          color: ColorStyle.textBlackColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget carComponent({required String title, image, rating, commands, price}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: const BoxDecoration(
        color: ColorStyle.carComponentBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              title,
              style: GoogleFonts.lato(
                color: ColorStyle.fontColorLight,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Text(
                  "$rating",
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontSize: 14.0,
                  ),
                ),
                SvgPicture.asset(Assets.star),
                Text(
                  "($commands commandes)",
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontSize: 14.0,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "$price FCFA /jour",
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
