import '../../../../common/app_sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/common_fonctions.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../theme/theme.dart';
import '../../widgets/form_input_field.dart';
import '../../widgets/primary_button.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({super.key});
  final _formKey = GlobalKey<FormState>();
  final UpdateProfileController _updateProfileController =
      Get.put(UpdateProfileController());
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    _updateProfileController.fullNameTextController.text =
        "${_userController.currentuser?.completeName}";
    _updateProfileController.phoneTextController.text =
        _userController.currentuser?.phoneNumber ?? '';
    _updateProfileController.emailTextController.text =
        _userController.currentuser?.email ?? '';
    // _updateProfileController.passwordTextController.text = "************";
    return Scaffold(
      backgroundColor: ColorStyle.lightWhiteBackground,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
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
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 30.0, bottom: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mettre à jour les informations du profil',
                        style: GoogleFonts.lato(
                          color: ColorStyle.fontColorLight,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      gapH30,
                      FormInputField(
                        labelText: 'Nom',
                        placeholder: 'Entrez votre nom complet',
                        fillColor: ColorStyle.bgFieldGrey,
                        filled: true,
                        textInputType: TextInputType.text,
                        controller:
                            _updateProfileController.fullNameTextController,
                        fieldValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre nom complet';
                          }
                          return null;
                        },
                      ),
                      gapH18,
                      FormInputField(
                        // readOnly: true,
                        readOnly: _updateProfileController
                            .phoneTextController.text.isNotEmpty,
                        // initialValue: _userController.currentuser?.phoneNumber,
                        labelText: 'Téléphone',
                        placeholder: '(999) 999-9999',
                        hasCountry: true,
                        fillColor: ColorStyle.bgFieldGrey,
                        filled: true,
                        textInputType: TextInputType.phone,
                        controller:
                            _updateProfileController.phoneTextController,
                        fieldValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre téléphone';
                          }
                          return null;
                        },
                      ),
                      gapH18,
                      FormInputField(
                        // readOnly: true,
                        readOnly: _updateProfileController
                            .emailTextController.text.isNotEmpty,
                        // initialValue: _userController.currentuser?.email,
                        labelText: 'Email',
                        placeholder: 'Entrez votre email',
                        fillColor: ColorStyle.bgFieldGrey,
                        filled: true,
                        textInputType: TextInputType.emailAddress,
                        controller:
                            _updateProfileController.emailTextController,
                        fieldValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          } else if (!emailRegex().hasMatch(value)) {
                            return 'Veuillez entrer une adresse e-mail valide';
                          }
                          return null;
                        },
                      ),
                      // gapH18,
                      // FormInputField(
                      //   // initialValue: "************",
                      //   labelText: 'Mot de passe',
                      //   placeholder: 'Entrez votre mot de passe',
                      //   fillColor: ColorStyle.bgFieldGrey,
                      //   filled: true,
                      //   password: true,
                      //   textInputType: TextInputType.visiblePassword,
                      //   controller:
                      //       _updateProfileController.passwordTextController,
                      //   fieldValidator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Veuillez entrer un mot de passe';
                      //     }
                      //     return null;
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 20.0),
                child: PrimaryButton(
                  title: 'Enregistrer',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateProfileController.updateUserprofile();
                    }
                    // Get.offAllNamed('/confirm_otp');
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
