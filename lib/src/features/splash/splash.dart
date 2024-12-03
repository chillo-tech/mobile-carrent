import '../../../helpers/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/splash_controller.dart';
import '../../../env.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashController = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          _logoImage(
            330.0,
            126.0,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  Env.getEnv(),
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _logoImage(double top, left) {
  return Container(
    alignment: FractionalOffset.center,
    // child: Row(
    //   crossAxisAlignment: CrossAxisAlignment.end,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Text('Carrent',
    //         style: GoogleFonts.lato(
    //           color: ColorStyle.white,
    //           fontSize: 24.0,
    //           fontWeight: FontWeight.bold,
    //         )),
    //         SvgPicture.asset(Assets.key_logo),
    //   ],
    // ),
    child: SvgPicture.asset(
      Assets.app_logo,
      // height: 152.0,
      // width: 123.2,
    ),
  );
}

Widget _backImage(double top, left) {
  return Container(
    transform: Matrix4.translationValues(left, top, 0.0),
    child: Image.asset(
      "assets/screen_bg.png",
      height: 75.11,
      width: 93.71,
    ),
  );
}
