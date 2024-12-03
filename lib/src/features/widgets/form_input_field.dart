import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/countries_controller.dart';
import '../../../theme/theme.dart';
import 'countries_dropdown.dart';

class FormInputField extends StatefulWidget {
  final String? labelText;
  final String? placeholder;
  final FormFieldValidator<String>? fieldValidator;
  final bool password;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? initialValue;
  final int? maxLength;
  final double borderWidth;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final int? minLines, maxLines;
  final Widget? suffix;
  final Widget? prefix;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool filled;
  final Color? fillColor;
  final bool isUppercase;
  final readOnly;
  final dynamic onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isRequired;
  final bool hasCountry;
  final bool isDoubleOnLine;
  final bool hasBorderRadius;

  FormInputField({
    this.labelText,
    this.placeholder,
    this.fieldValidator,
    this.password = false,
    this.textInputType,
    this.textInputAction,
    this.controller,
    this.initialValue,
    this.maxLength,
    this.borderWidth = 3.0,
    this.enabled = true,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.suffix,
    this.onFieldSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.filled = false,
    this.fillColor,
    this.prefix,
    this.readOnly = false,
    this.onTap,
    this.isUppercase = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = true,
    this.hasCountry = false,
    this.isDoubleOnLine = false,
    this.hasBorderRadius = false,
  });

  @override
  _FormInputFieldState createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  var _passwordVisible = false;
  CountriesController countriesController = Get.put(CountriesController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isDoubleOnLine
          ? MediaQuery.of(context).size.width / 2.2
          : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.labelText != null
              ? Text(
                  widget.isUppercase
                      ? widget.labelText!.toUpperCase()
                      : widget.labelText!.toLowerCase().capitalizeEachWord,
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 5.0),
          widget.hasCountry
              ? Row(
                  children: [
                    CountriesDropdown(
                        countries: countriesController.countriesResponse,
                        value: countriesController.selectedCountry.value,
                        onChanged: (country) {
                          countriesController.selectedCountry.value = country;
                        }),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.715,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        inputFormatters: widget.inputFormatters,
                        focusNode: widget.focusNode,
                        onFieldSubmitted: widget.onFieldSubmitted,
                        onChanged: widget.onChanged,
                        enabled: widget.enabled,
                        minLines: widget.minLines,
                        maxLines: !widget.password ? widget.maxLines : 1,
                        validator: widget.fieldValidator,
                        obscureText: widget.password && !_passwordVisible,
                        maxLength: widget.maxLength,
                        keyboardType: widget.textInputType,
                        textInputAction: widget.textInputAction,
                        controller: widget.controller,
                        initialValue: widget.initialValue,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          filled: widget.filled,
                          fillColor: widget.fillColor,
                          suffixIcon: widget.password &&
                                  widget.suffixIcon == null
                              ? Opacity(
                                  opacity: _passwordVisible ? 1 : 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Icon(
                                          _passwordVisible
                                              ? FontAwesomeIcons.solidEye
                                              : FontAwesomeIcons.solidEyeSlash,
                                          size: 16.0),
                                      onTap: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ))
                              : widget.suffixIcon == null
                                  ? widget.suffix
                                  : widget.suffixIcon,
                          hintText:
                              widget.labelText == 'input.recommended_by'.tr
                                  ? "enter_phone_number".tr
                                  : widget.placeholder,
                          hintStyle: GoogleFonts.lato(
                            color: ColorStyle.hintColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                          prefix: widget.prefix,
                          prefixIcon: widget.prefixIcon,
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(5)),
                          //   borderSide: BorderSide(
                          //       color: widget.borderWidth == 0
                          //           ? Colors.transparent
                          //           : Theme.of(context).colorScheme.secondary,
                          //       width: 1.0),
                          // ),
                          // contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(5)),
                          //   borderSide: BorderSide(
                          //       color: widget.borderWidth == 0
                          //           ? Colors.transparent
                          //           : ColorStyle.borderColor,
                          //       width: 1.0),
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(5)),
                          //   borderSide: BorderSide(
                          //       color: widget.borderWidth == 0
                          //           ? Colors.transparent
                          //           : ColorStyle.borderColor,
                          //       width: 1.0),
                          // ),
                        ),
                        readOnly: widget.readOnly,
                        onTap: widget.onTap,
                      ),
                    ),
                  ],
                )
              : TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  inputFormatters: widget.inputFormatters,
                  focusNode: widget.focusNode,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  onChanged: widget.onChanged,
                  enabled: widget.enabled,
                  minLines: widget.minLines,
                  maxLines: !widget.password ? widget.maxLines : 1,
                  validator: widget.fieldValidator,
                  obscureText: widget.password && !_passwordVisible,
                  maxLength: widget.maxLength,
                  keyboardType: widget.textInputType,
                  textInputAction: widget.textInputAction,
                  controller: widget.controller,
                  initialValue: widget.initialValue,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    filled: widget.filled,
                    fillColor: widget.fillColor,
                    suffixIcon: widget.password && widget.suffixIcon == null
                        ? Opacity(
                            opacity: _passwordVisible ? 1 : 0.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                child: Icon(
                                    _passwordVisible
                                        ? FontAwesomeIcons.solidEye
                                        : FontAwesomeIcons.solidEyeSlash,
                                    size: 16.0),
                                onTap: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ))
                        : widget.suffixIcon == null
                            ? widget.suffix
                            : widget.suffixIcon,
                    hintText: widget.labelText == 'input.recommended_by'.tr
                        ? "enter_phone_number".tr
                        : widget.placeholder,
                    hintStyle: GoogleFonts.lato(
                      color: ColorStyle.hintColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                    ),
                    prefix: widget.prefix,
                    prefixIcon: widget.prefixIcon,
                    focusedBorder: widget.hasBorderRadius
                        ? OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorStyle.bgFieldGrey,
                              width: 1.3,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          )
                        : null,
                    // contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                    border: widget.hasBorderRadius
                        ? OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorStyle.lightPrimaryColor,
                              width: 1.3,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          )
                        : null,
                    enabledBorder: widget.hasBorderRadius
                        ? OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorStyle.bgFieldGrey,
                              width: 1.3,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          )
                        : null,
                  ),
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                ),
        ],
      ),
    );
  }
}

extension CapExtension on String {
  String get capitalizeEachWord =>
      this.split(" ").map((str) => str.capitalize).join(" ");
}
