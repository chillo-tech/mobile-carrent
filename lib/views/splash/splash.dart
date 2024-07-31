import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_controller.dart';

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
          // Container(
          //   alignment: Alignment.bottomCenter,
          //   margin: EdgeInsets.only(bottom: 16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     mainAxisSize: MainAxisSize.max,
          //     children: [
          //       Text(
          //         Environment.getEnv(),
          //         style: TextStyle(
          //           color: Colors.white60,
          //           fontSize: 14.0,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

Widget _logoImage(double top, left) {
  return Container(
    alignment: FractionalOffset.center,
    child: Image.asset(
      "assets/logo.png",
      height: 152.0,
      width: 123.2,
    ),
  );
}

Widget _backImage(double top, left) {
  return Container(
    child: Image.asset(
      "assets/screen_bg.png",
      height: 75.11,
      width: 93.71,
    ),
    transform: Matrix4.translationValues(left, top, 0.0),
  );
}
