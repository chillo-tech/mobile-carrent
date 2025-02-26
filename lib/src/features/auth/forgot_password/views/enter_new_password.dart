import 'package:carrent/src/features/auth/forgot_password/views/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../common/common_fonctions.dart';
import '../../../../../theme/theme.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/form_input_field.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/forgot_password_controller.dart';

class EnterNewPassword extends StatefulWidget {
  EnterNewPassword({super.key});

  @override
  State<EnterNewPassword> createState() => _EnterNewPasswordState();
}

class _EnterNewPasswordState extends State<EnterNewPassword> {
  ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.lightWhiteBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 30.0, bottom: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entrez votre nouveau mot de passe',
                      style: GoogleFonts.lato(
                        color: ColorStyle.fontColorLight,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    const SizedBox(height: 25.0),
                    FormInputField(
                      labelText: 'Nouveau mot de passe',
                      placeholder: 'Entrez votre nouveau mot de passe',
                      fillColor: ColorStyle.bgFieldGrey,
                      filled: true,
                      password: true,
                      controller:
                          forgotPasswordController.newPasswordInputController,
                      textInputType: TextInputType.text,
                      fieldValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un mot de passe';
                        }
                        if (!passwordRegex().hasMatch(value)) {
                          return "Le mot de passe doit etre d'au moins 6 caractères";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            passwordRegex().hasMatch(value)) {
                          setState(() {});
                          _formKey.currentState!.validate();
                        }
                      },
                    ),
                    const SizedBox(height: 25.0),
                    FormInputField(
                      labelText: 'Répétez le mot de passe',
                      placeholder: 'Répétez le nouveau mot de passe',
                      fillColor: ColorStyle.bgFieldGrey,
                      filled: true,
                      password: true,
                      controller: forgotPasswordController
                          .newPasswordConfirmInputController,
                      textInputType: TextInputType.text,
                      fieldValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un mot de passe';
                        } else if (!passwordRegex().hasMatch(value)) {
                          return "Le mot de passe doit etre d'au moins 6 caractères";
                        } else if (forgotPasswordController
                                .newPasswordInputController.text !=
                            value) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            passwordRegex().hasMatch(value)) {
                          setState(() {});
                          _formKey.currentState!.validate();
                        } else {
                          setState(() {});
                          // _formKey.currentState!.;
                        }
                      },
                    ),
                    const SizedBox(height: 30.0),
                    PrimaryButton(
                      title: 'Réinitialiser le mot de passe',
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            forgotPasswordController
                                    .newPasswordInputController.text ==
                                forgotPasswordController
                                    .newPasswordConfirmInputController.text) {
                          forgotPasswordController.setUpNewPassword();
                        }
                      },
                    ),
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
