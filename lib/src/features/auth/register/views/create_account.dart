import '../../../../../common/common_fonctions.dart';
import '../../../../../controllers/countries_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/primary_button.dart';
import '../controllers/register_controller.dart';
import '../../../../../theme/theme.dart';
import '../../../widgets/form_input_field.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({super.key});
  CountriesController countriesController = Get.put(CountriesController());
  RegisterController registerController = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.lightWhiteBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 30.0, bottom: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Carrent',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Créez votre compte',
                    style: GoogleFonts.lato(
                      color: ColorStyle.fontColorLight,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  FormInputField(
                    labelText: 'Nom complet',
                    placeholder: 'Entrez votre nom complet',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    controller: registerController.fullNameTextController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre nom complet';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25.0),
                  FormInputField(
                    labelText: 'Téléphone',
                    placeholder: '(999) 999-9999',
                    hasCountry: true,
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.phone,
                    controller: registerController.phoneTextController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre téléphone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  FormInputField(
                    labelText: 'Email',
                    placeholder: 'Entrez votre email',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.emailAddress,
                    controller: registerController.emailTextController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (!emailRegex().hasMatch(value)) {
                        return 'Veuillez entrer une adresse e-mail valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25.0),
                  FormInputField(
                    labelText: 'Mot de passe',
                    placeholder: 'Entrez votre mot de passe',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    password: true,
                    textInputType: TextInputType.visiblePassword,
                    controller: registerController.passwordTextController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  PrimaryButton(
                    title: 'Créer un compte',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        registerController.createAccount();
                      }
                      // Get.offAllNamed('/confirm_otp');
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 98.0,
                          height: 2.0,
                          decoration: const BoxDecoration(
                              color: ColorStyle.dividerColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Ou',
                          style: GoogleFonts.lato(
                            color: ColorStyle.dividerColor,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 98.0,
                          height: 2.0,
                          decoration: const BoxDecoration(
                              color: ColorStyle.dividerColor),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 15.0),
                  // PrimaryButton(
                  //   title: 'Continuer avec Google',
                  //   image: 'assets/icons/google.svg',
                  //   color: ColorStyle.lightWhite,
                  //   textColor: ColorStyle.fontColorLight,
                  //   onPressed: () {
                  //     Get.offAllNamed('/bottom_nav');
                  //   },
                  // ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/login');
                    },
                    child: Center(
                      child: Text.rich(TextSpan(
                          text: "Vous avez déjà un compte ? ",
                          style: GoogleFonts.lato(
                            color: ColorStyle.fontColorLight,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                                text: "Connexion",
                                style: GoogleFonts.lato(
                                  color: ColorStyle.lightPrimaryColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ))
                          ])),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
