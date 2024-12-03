import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme.dart';

class BackBottomButton extends StatelessWidget {
  const BackBottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: ColorStyle.lightWhite,
                borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 15.0,
                ),
                const SizedBox(width: 10.0),
                Text(
                  'Retour',
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
