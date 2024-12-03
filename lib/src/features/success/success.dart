import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helpers/assets.dart';
import '../../../theme/theme.dart';
import '../widgets/back_button.dart';
import '../widgets/primary_button.dart';

class Success extends StatelessWidget {
  Success({super.key});

  final String title = Get.arguments['title'];
  final String description = Get.arguments['description'];
  final String buttonTitle = Get.arguments['buttonTitle'];
  final String route = Get.arguments['route'];
  final String? argument = Get.arguments['operation_type'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.lightWhiteBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 30.0, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(Assets.success),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: ColorStyle.fontColorLight,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: ColorStyle.fontColorLight,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    PrimaryButton(
                      title: buttonTitle,
                      onPressed: () {
                        if (argument != null) {
                          Get.offNamed(route,
                              arguments: {'operationType': argument});
                        } else {
                          Get.offNamed(route);
                        }
                      },
                    )
                  ],
                ),
              ),
              const BackBottomButton()
            ],
          ),
        ),
      ),
    );
  }
}
