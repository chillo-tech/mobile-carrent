import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ToastController extends GetxController {
  String? title;
  String? message;

  ToastController({this.title, this.message});

  void showToast([Duration duration = const Duration(seconds: 3)]) {
    BotToast.showText(
      text: message ?? "",
      contentColor: Colors.grey.shade900,
      duration: duration,
      textStyle: GoogleFonts.lato(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }
}
