import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool? isRoundedBorder;
  final Color? color;
  final Color? textColor;
  final String? image;
  final bool isHalfWidth;
  const PrimaryButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isRoundedBorder,
      this.isHalfWidth = false,
      this.color = ColorStyle.lightPrimaryColor,
      this.image,
      this.textColor = ColorStyle.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: isHalfWidth
            ? MediaQuery.of(context).size.width / 2
            : double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            isRoundedBorder != null && isRoundedBorder! ? 20.0 : 8.0,
          ),
        ),
        height: 48.0,
        alignment: FractionalOffset.center,
        // child: Text(
        //   title,
        //   style: GoogleFonts.lato(
        //     color: textColor,
        //     fontSize: 18.0,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null ? SvgPicture.asset(image!) : const SizedBox(),
            image != null ? const SizedBox(width: 10.0) : const SizedBox(),
            Text(
              title,
              style: GoogleFonts.lato(
                color: textColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
