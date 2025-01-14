import 'package:carrent/src/features/auth/forgot_password/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../common/common_fonctions.dart';
import '../../../../../theme/theme.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/form_input_field.dart';
import '../../../widgets/primary_button.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());

      final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.lightWhiteBackground,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 30.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Text(
                        forgotPasswordController.resetWithEmail.value
                            ? 'Entrez votre email et nous vous enverrons un lien pour réinitialiser votre mot de passe'
                            : 'Entrez votre téléphone et nous vous enverrons un lien pour réinitialiser votre mot de passe',
                        style: GoogleFonts.lato(
                          color: ColorStyle.fontColorLight,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }),
                    const SizedBox(height: 30.0),
                    Obx(() {
                      return Row(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: forgotPasswordController
                                      .resetWithEmail.value,
                                  onChanged: (bool? value) {
                                    forgotPasswordController
                                        .resetWithEmail.value = true;
                                    forgotPasswordController
                                        .resetWithPhone.value = false;
                                    forgotPasswordController.emailInputController
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
                                  value: forgotPasswordController
                                      .resetWithPhone.value,
                                  onChanged: (bool? value) {
                                    forgotPasswordController
                                        .resetWithEmail.value = false;
                                    forgotPasswordController
                                        .resetWithPhone.value = true;
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
                      return forgotPasswordController.resetWithPhone.value
                          ? FormInputField(
                              labelText: 'Téléphone',
                              placeholder: '(999) 999-9999',
                              hasCountry: true,
                              fillColor: ColorStyle.bgFieldGrey,
                              filled: true,
                              textInputType: TextInputType.phone,
                              controller:
                                  forgotPasswordController.phoneInputController,
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
                                  forgotPasswordController.emailInputController,
                              fieldValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre e-mail';
                                }

                                if (!emailRegex().hasMatch(value)) {
                                  return 'Veuillez entrer une adresse e-mail valide';
                                }
                                return null;
                              },
                            );
                    }),
                    // FormInputField(
                    //   labelText: 'Adresse e-mail',
                    //   placeholder: 'Entrez votre adresse e-mail',
                    //   fillColor: ColorStyle.bgFieldGrey,
                    //   filled: true,
                    //   textInputType: TextInputType.emailAddress,
                    //   fieldValidator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Veuillez entrer votre email';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 30.0),
                    Obx(() {
                      return PrimaryButton(
                        title: forgotPasswordController.resetWithEmail.value
                            ? 'Envoyer le lien par email'
                            : 'Envoyer le lien par sms',
                        onPressed: () {
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          forgotPasswordController.sendEmailOrSms();
                        },
                      );
                    }),
                  ],
                ),
                const BackBottomButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
