import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/app_sizes.dart';
import '../../../../../theme/theme.dart';
import '../../../../../utils/utility.dart';

class DetailsBlock extends StatelessWidget {
  const DetailsBlock({
    Key? key,
    required this.blockDetails,
    required this.title,
    this.carMake,
    this.carModel,
  }) : super(key: key);

  final List<Map<String, dynamic>> blockDetails;
  final String title;
  final String? carMake;
  final String? carModel;

  @override
  Widget build(BuildContext context) {
    if (blockDetails.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            color: ColorStyle.fontColorLight,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        gapH10,
        ...blockDetails.map((detail) => _DetailItem(
              detail: detail,
              title: title,
              carMake: carMake,
              carModel: carModel,
            )),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.detail,
    required this.title,
    this.carMake,
    this.carModel,
  });

  final Map<String, dynamic> detail;
  final String title;
  final String? carMake;
  final String? carModel;

  bool get isIconString => detail['icon'] is String;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          splashColor: isIconString ? ColorStyle.lightWhiteBackground : null,
          onTap: () => _handleTap(),
          child: Row(
            children: [
              _buildIcon(),
              gapW8,
              _buildTextContent(),
            ],
          ),
        ),
        gapH8,
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: ColorStyle.lightGreyColor1,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: isIconString
          ? SvgPicture.asset(detail['icon'])
          : Icon(detail['icon'], size: 14.0),
    );
  }

  Widget _buildTextContent() {
    final titleText = detail['title'] ?? '';
    final descriptionText = detail['description'];

    if (descriptionText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: GoogleFonts.lato(
              color: ColorStyle.fontColorLight,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            descriptionText,
            style: GoogleFonts.lato(
              color: ColorStyle.fontColorLight,
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    } else {
      return Text(
        titleText,
        style: GoogleFonts.lato(
          color: ColorStyle.fontColorLight,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }

  Future<void> _handleTap() async {
    if (detail['icon'] is! String) {
      final contactValue =
          title == 'Reservée par' ? detail['description'] : detail['title'];

      if (title == 'Reservée par' && contactValue.contains('@')) {
        await launchUrl(
          Uri.parse(
              'mailto:$contactValue?subject=Location de ${carMake ?? ''} ${carModel ?? ''}'),
        );
      } else {
        Get.dialog(
          Utility.tripleActionDialog(
            title: title == 'Reservée par'
                ? "Contacter le locataire"
                : "Contacter le propriétaire",
            content:
                "Choisissez le moyen de communication que vous souhaitez utiliser pour contacter ${title == 'Reservée par' ? 'le locataire' : 'le propriétaire'}",
            firstButtonText: 'Appel',
            onFirstPressed: () async =>
                await launchUrl(Uri.parse('tel:$contactValue')),
            secondButtonText: 'SMS',
            onSecondPressed: () async =>
                await launchUrl(Uri.parse('sms:$contactValue')),
            thirdButtonText: 'Whatsapp',
            onThirdPressed: () async =>
                await launchUrl(Uri.parse('https://wa.me/$contactValue')),
          ),
        );
      }
    }
  }
}
