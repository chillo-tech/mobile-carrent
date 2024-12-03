import '../../../../../theme/theme.dart';
import '../../../widgets/form_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/primary_button.dart';
import '../controllers/login_controller.dart';

class Login extends StatelessWidget {
  Login({super.key});
  LoginController loginController = Get.put(LoginController());
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
                    'Connectez-vous à votre compte',
                    style: GoogleFonts.lato(
                      color: ColorStyle.fontColorLight,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Obx(() {
                    return Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: loginController.loginWithEmail.value,
                                onChanged: (bool? value) {
                                  loginController.loginWithEmail.value = true;
                                  loginController.loginWithPhone.value = false;
                                  loginController.loginEmailTextController
                                      .clear();
                                }),
                            Text("Email",
                                style: GoogleFonts.lato(
                                  color: ColorStyle.fontColorLight,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ))
                          ],
                        ),
                        const SizedBox(width: 10.0),
                        Row(
                          children: [
                            Checkbox(
                                value: loginController.loginWithPhone.value,
                                onChanged: (bool? value) {
                                  loginController.loginWithEmail.value = false;
                                  loginController.loginWithPhone.value = true;
                                }),
                            Text("Téléphone",
                                style: GoogleFonts.lato(
                                  color: ColorStyle.fontColorLight,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ))
                          ],
                        )
                      ],
                    );
                  }),
                  const SizedBox(height: 15.0),
                  Obx(() {
                    return loginController.loginWithPhone.value
                        ? FormInputField(
                            labelText: 'Téléphone',
                            placeholder: '(999) 999-9999',
                            hasCountry: true,
                            fillColor: ColorStyle.bgFieldGrey,
                            filled: true,
                            textInputType: TextInputType.phone,
                            controller:
                                loginController.loginEmailTextController,
                            fieldValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre téléphone';
                              }
                              return null;
                            },
                          )
                        : FormInputField(
                            labelText: 'Adresse e-mail',
                            placeholder: 'Entrez votre adresse e-mail',
                            fillColor: ColorStyle.bgFieldGrey,
                            filled: true,
                            textInputType: TextInputType.emailAddress,
                            controller:
                                loginController.loginEmailTextController,
                            fieldValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre e-mail';
                              }
                              return null;
                            },
                          );
                  }),
                  const SizedBox(height: 25.0),
                  FormInputField(
                    labelText: 'Mot de passe',
                    placeholder: 'Entrez votre mot de passe',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    password: true,
                    textInputType: TextInputType.visiblePassword,
                    controller: loginController.loginPasswordTextController,
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/forgot_password");
                        },
                        child: Column(
                          children: [
                            Text(
                              'Mot de passe oublié ?',
                              style: GoogleFonts.lato(
                                color: ColorStyle.lightPrimaryColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              width: 135.0,
                              height: 1.5,
                              decoration: const BoxDecoration(
                                  color: ColorStyle.lightPrimaryColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  PrimaryButton(
                    title: 'Connexion',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginController.authenticate();
                      }
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
                  const SizedBox(height: 15.0),
                  PrimaryButton(
                    title: 'Continuer avec Google',
                    image: 'assets/icons/google.svg',
                    color: ColorStyle.lightWhite,
                    textColor: ColorStyle.fontColorLight,
                    onPressed: () {
                      Get.offAllNamed('/bottom_nav');
                    },
                  ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/create_account');
                    },
                    child: Center(
                      child: Text.rich(TextSpan(
                          text: "Vous n'avez pas de compte ? ",
                          style: GoogleFonts.lato(
                            color: ColorStyle.fontColorLight,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                                text: "Inscrivez-vous",
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
