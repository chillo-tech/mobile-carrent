import '../../../../theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../controllers/bookings_controller.dart';

class Bookings extends StatelessWidget {
  const Bookings({super.key});
  // final BookingsController _bookingsController = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Center(
        child: Text(
          'Fonctionnalité à venir bientôt',
          style: GoogleFonts.lato(
            color: ColorStyle.textBlackColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
            // fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
