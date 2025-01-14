import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import '../controllers/countries_controller.dart';
import '../models/african_country.dart';
import '../models/carrent_country.dart';
import '../network/auth_headers.dart';
import '../theme/theme.dart';

/// This class handle the display of some of the dialog in the app
/// such as [PreviewImage], [PreviewMultiplefile], [DisplayTheListOfCountry]
/// [OpenTermsAndConditionDialofURl], a container widget to display image from base64String
class Utility {
  static final amountFormatter = NumberFormat("#,##0");
  static final amountFormatterWithoutDecimal = NumberFormat("#,##0");

  static String encodeDate(DateTime dateTime) =>
      DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime);

  static String dateFormat(DateTime dateTime) =>
      DateFormat('MMM d, yyyy').format(dateTime);

  static bool isImage(String path) {
    final mimeType = lookupMimeType(path);

    return (mimeType?.startsWith('image/') ?? false);
  }

  static String removePhonePrefix(String number) {
    if (number.startsWith("00")) number = number.substring(2, number.length);
    if (number.startsWith('+')) number = number.substring(1, number.length);
    var countriesController = Get.put(CountriesController());

    for (int i = 0; i < countriesController.countriesResponse.length; i++) {
      CarrentCountry element = countriesController.countriesResponse[i];

      if (number.startsWith("${element.phonecode}")) {
        number = number.replaceAll(element.phonecode.toString(), "");
        break;
      }
    }

    number = number.replaceAll(RegExp(r'[^0-9]*'), "");

    return number;
  }

  static void previewImage(BuildContext context, File imageFile,
      {String url = "", Map<String, String>? headers}) {
    AuthHeaders _authHeaders = AuthHeaders();
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0.0),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Get.back();
                        }),
                  ),
                  if (url.isEmpty)
                    Image.file(
                      imageFile,
                      width: 500,
                    ),
                  if (url.isNotEmpty)
                    FutureBuilder(
                        future: _authHeaders.setAuthHeaders(),
                        builder: (context,
                            AsyncSnapshot<Map<String, String>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: Get.theme.colorScheme.secondary),
                            );
                          }
                          return Image(
                            width: 500,
                            image: NetworkImage(url, headers: snapshot.data),
                            errorBuilder: (context, error, trace) =>
                                Image.asset('assets/profile/avatar.png'),
                          );
                        })
                ],
              ),
            ),
          );
        });
  }

  static void showCountryDialog(
      BuildContext context,
      List<AfricanCountry> countries,
      Function(AfricanCountry) selectedCountry) {
    RxList<AfricanCountry> filterCountries = RxList.from(List.from(countries));
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              backgroundColor: Theme.of(context).canvasColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'register.customer.country_code'.tr,
                      style: const TextStyle(
                          fontSize: 18, color: ColorStyle.textBlackColor1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: ColorStyle.borderColor, width: 1.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: ColorStyle.borderColor, width: 1.0),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'search_country'.tr,
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          filterCountries.value = countries
                              .where((element) => (element.name
                                      ?.toLowerCase()
                                      .contains(value.trim().toLowerCase()) ??
                                  false))
                              .toList();
                        } else {
                          filterCountries.value = List.from(countries);
                        }
                      },
                    ),
                  ),
                  Expanded(
                      child: Obx(
                    () => ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 20,
                                ),
                                child: Text(
                                  "${filterCountries[index].name} (${filterCountries[index].dialCode})",
                                  style: const TextStyle(
                                      color: ColorStyle.textBlackColor1,
                                      fontSize: 15),
                                ),
                              ),
                              onTap: () {
                                selectedCountry(filterCountries[index]);
                                Get.back();
                              },
                            ),
                        separatorBuilder: (context, index) => const Divider(
                              height: 0,
                              thickness: 0.5,
                              color: ColorStyle.borderColor,
                            ),
                        itemCount: filterCountries.length),
                  )),
                ],
              ),
            ));
  }

  static Widget getImageFromBase64String(String base64String) {
    const Base64Codec base64 = Base64Codec();
    var bytes = base64.decode(base64String);
    return Container(
      child: Image.memory(
        bytes,
      ),
    );
  }

  /// Format amount to be shown on screens.
  /// Set `withDecimal` at `true` to parse amount
  /// and show decimals.
  static String formatAmount(amount, [withDecimal = true]) {
    if (withDecimal)
      return amountFormatter.format(amount).replaceAll(',', ' ');
    else
      return amountFormatterWithoutDecimal.format(amount).replaceAll(',', ' ');
  }

  static Widget simpleDialog({
    required String title,
    required String content,
    String continueButtonText = "Continuer",
    VoidCallback? onContinuePressed,
  }) {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset('assets/alert.png'),
              // const SizedBox(height: 16),
              Text(
                title!,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // onBackPressed != null
              //     ?
              // Expanded(
              //   child:
              Row(
                children: [
                  Expanded(
                    child: IntrinsicHeight(
                      child: ElevatedButton(
                        onPressed: onContinuePressed,
                        child: Text(
                          continueButtonText,
                          style: GoogleFonts.lato(
                            color: ColorStyle.white,
                            fontSize: 16.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Get.theme.primaryColor,
                          textStyle: GoogleFonts.lato(
                            color: ColorStyle.white,
                            fontSize: 16.0,
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // )
              // : IntrinsicHeight(
              //     child: ElevatedButton(
              //       onPressed: onContinuePressed,
              //       child: Text(
              //         'Continuer'.tr,
              //         style: GoogleFonts.lato(
              //           color: ColorStyle.white,
              //           fontSize: 16.0,
              //         ),
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Get.theme.primaryColor,
              //         textStyle: GoogleFonts.lato(
              //           color: ColorStyle.white,
              //           fontSize: 16.0,
              //         ),
              //         elevation: 0,
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 15,
              //           vertical: 14,
              //         ),
              //       ),
              //     ),
              //   )
            ],
          ),
        )
      ],
    );
  }

  static Widget simpleBinaryDialog({
    required String title,
    required String content,
    String backButtonText = "Annuler",
    String continueButtonText = "Continuer",
    VoidCallback? onBackPressed,
    VoidCallback? onContinuePressed,
  }) {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset('assets/alert.png'),
              // const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // onBackPressed != null
              //     ?
              Row(
                children: [
                  if (onBackPressed != null)
                    Expanded(
                      child: IntrinsicHeight(
                        child: OutlinedButton(
                          onPressed: onBackPressed,
                          child: Text(
                            backButtonText,
                            style: GoogleFonts.lato(
                              color: ColorStyle.lightPrimaryColor,
                              fontSize: 16.0,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Get.theme.primaryColor,
                            side: BorderSide(color: Get.theme.primaryColor),
                            textStyle: GoogleFonts.lato(
                              color: ColorStyle.lightPrimaryColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (onBackPressed != null) const SizedBox(width: 15),
                  Expanded(
                    child: IntrinsicHeight(
                      child: ElevatedButton(
                        onPressed: onContinuePressed,
                        child: Text(
                          continueButtonText,
                          style: GoogleFonts.lato(
                            color: ColorStyle.white,
                            fontSize: 16.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Get.theme.primaryColor,
                          textStyle: GoogleFonts.lato(
                            color: ColorStyle.white,
                            fontSize: 16.0,
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              // : IntrinsicHeight(
              //     child: ElevatedButton(
              //       onPressed: onContinuePressed,
              //       child: Text(
              //         'Continuer'.tr,
              //         style: GoogleFonts.lato(
              //           color: ColorStyle.white,
              //           fontSize: 16.0,
              //         ),
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Get.theme.primaryColor,
              //         textStyle: GoogleFonts.lato(
              //           color: ColorStyle.white,
              //           fontSize: 16.0,
              //         ),
              //         elevation: 0,
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 15,
              //           vertical: 14,
              //         ),
              //       ),
              //     ),
              //   )
            ],
          ),
        )
      ],
    );
  }

  static void showLoader(String title, [String? description]) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 48.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
          color: Colors.white,
        ),
        child: Wrap(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                color: const Color(0xFF18191A),
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            if (description != null && description.isNotEmpty)
              Container(height: 10.0),
            if (description != null && description.isNotEmpty)
              Text(
                description,
                style: GoogleFonts.inter(
                  color: const Color(0xFF858381),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            Container(height: 48.0),
            Center(
              child: LinearProgressIndicator(
                backgroundColor: const Color(0xFFFFBEBE),
                color: Get.theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 250),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
    );
  }

  static String isoToEmoji(String code) {
    return code
        .split('')
        .map((letter) =>
            String.fromCharCode(letter.codeUnitAt(0) % 32 + 0x1F1E5))
        .join('');
  }
}
