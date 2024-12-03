import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../widgets/primary_button.dart';
import '../controllers/otp_controller.dart';
import '../../../../../theme/theme.dart';
import '../../../widgets/back_button.dart';

class ConfirmOtp extends StatelessWidget {
  ConfirmOtp({super.key});

  final _formKey = GlobalKey<FormState>();
  final OtpController otpController = Get.put(OtpController());
  final _otpValidator = MultiValidator([
    LengthRangeValidator(
        min: 6, max: 6, errorText: 'veuillez entrer un OTP valide'.tr)
  ]);
  String operationType = Get.arguments['operationType'];

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
                      'Entrez votre email et nous vous enverrons un lien pour réinitialiser votre mot de passe',
                      style: GoogleFonts.lato(
                        color: ColorStyle.fontColorLight,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: PinCodeTextField(
                        autoFocus: true,
                        appContext: context,
                        textInputAction: TextInputAction.done,
                        enableActiveFill: true,
                        pastedTextStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textStyle: GoogleFonts.inter(
                          color: ColorStyle.lightPrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 28.0,
                        ),
                        length: 4,
                        obscureText: false,
                        cursorHeight: 2.0,
                        cursorWidth: 13.0,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          inactiveColor:
                              Theme.of(context).hintColor.withOpacity(0.6),
                          borderWidth: 1.2,
                          borderRadius: BorderRadius.circular(8.0),
                          fieldHeight: 50,
                          fieldWidth: 50,
                          selectedColor: ColorStyle.lightPrimaryColor,
                          activeColor: ColorStyle.lightPrimaryColor,
                          activeFillColor: const Color(0xFFFCEBEB),
                          disabledColor: const Color(0xFFAFB1B2),
                          inactiveFillColor: const Color(0xFFEAEAE9),
                          selectedFillColor: const Color(0xFFEAEAE9),
                        ),
                        cursorColor:
                            Theme.of(context).textSelectionTheme.selectionColor,
                        animationDuration: const Duration(milliseconds: 300),
                        // controller: otpController.otpTextController,
                        autoDisposeControllers: false,
                        keyboardType:
                            const TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        // validator: _otpValidator,
                        onCompleted: (v) {
                          if (_formKey.currentState?.validate() ?? false) {
                            otpController.onSubmitOTP(operationType);
                          }
                        },
                        onChanged: (value) {
                          otpController.otpTextController.text = value;
                        },
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    PrimaryButton(
                      title: 'Continuer',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          otpController.onSubmitOTP(operationType);
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Obx(
                      () {
                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: ColorStyle.lightWhite,
                                  borderRadius: BorderRadius.circular(18.0)),
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      "Renvoyer le code ",
                                      style: GoogleFonts.inter(
                                        color: otpController.leftTime.value ==
                                                "00:00"
                                            ? Get.theme.primaryColor
                                            : Get.theme.textSelectionTheme
                                                .selectionColor,
                                        fontSize: 16.0,
                                        fontWeight:
                                            otpController.leftTime.value ==
                                                    "00:00"
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                      ),
                                    ),
                                    // onTap: otpController.leftTime.value == "00:00"
                                    //     ? () =>
                                    //         otpController.resendRegistrationOTP()
                                    //     : null,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    otpController.leftTime.value,
                                    style: TextStyle(
                                      color: otpController.leftTime.value !=
                                              "00:00"
                                          ? Get.theme.primaryColor
                                          : Get.theme.textSelectionTheme
                                              .selectionColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
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
