import 'package:bot_toast/bot_toast.dart';

import '../../../helpers/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme.dart';
import '../widgets/primary_button.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.welcome,
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.white,
                ],
                stops: [0.0, 0.3, 0.3, 0.75],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Carrent',
                  style: GoogleFonts.lato(
                    color: Theme.of(context).primaryColor,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  'Welcome on Carrent',
                  style: GoogleFonts.lato(
                    color: ColorStyle.cardColorLight,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                PrimaryButton(
                    title: 'Login',
                    onPressed: () {
                      Get.offAllNamed('/login');
                    }),
                const SizedBox(height: 10.0),
                PrimaryButton(
                  title: 'Create an account',
                  color: ColorStyle.cardColorLight,
                  onPressed: () {
                    Get.offAllNamed('/create_account');
                  },
                ),
                const SizedBox(height: 10.0),
                PrimaryButton(
                  title: 'Login as visitor',
                  color: ColorStyle.grey,
                  textColor: ColorStyle.cardColorLight,
                  onPressed: () {
                    // BotToast.showText(
                    //   text: "Cette fonctionnalite sera bientot disponible",
                    //   contentColor: Colors.grey.shade900,
                    //   duration: Duration(seconds: 3),
                    //   textStyle: TextStyle(
                    //     fontSize: 14,
                    //     fontFamily: GoogleFonts.lato().fontFamily,
                    //     color: Colors.white,
                    //   ),
                    // );
                    Get.offAllNamed('/bottom_nav');
                  },
                ),
                const SizedBox(
                  height: 14.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
