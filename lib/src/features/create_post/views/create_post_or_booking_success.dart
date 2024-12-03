import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/theme.dart';
import '../../bottom_nav/controllers/bottom_nav_controller.dart';
import '../../widgets/primary_button.dart';

class CreatePostSuccess extends StatelessWidget {
  CreatePostSuccess({super.key});
  final BottomNavController _bottomNavController =
      Get.put(BottomNavController());

  final String image = Get.arguments['image'];
  final String title = Get.arguments['title'];
  final String description = Get.arguments['description'];
  final String buttonTitle = Get.arguments['buttonTitle'];
  final String route = Get.arguments['route'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(image),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          color: ColorStyle.fontColorLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          color: ColorStyle.greyColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 16.0),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PrimaryButton(
                title: 'Continuer',
                onPressed: () {
                  _bottomNavController.selectedIndex.value = 2;
                  Get.offAllNamed(route);
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
