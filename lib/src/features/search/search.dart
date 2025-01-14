import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/app_sizes.dart';
import '../../../theme/theme.dart';
import '../widgets/form_input_field.dart';
import 'controllers/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchBarController _searchBarController =
      Get.put(SearchBarController());
  final _formKey = GlobalKey<FormState>();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormInputField(
                    hasBorderRadius: true,
                    placeholder: 'Marque, prix, type, disponibilité, année...',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 18.0,
                    ),
                    onChanged: (value) {
                      _searchBarController.searchQuery.value = value;
                    },
                  ),
                  Obx(() {
                    final filteredSections = _searchBarController
                        .searchASections(_searchBarController.searchSections());

                    return ListView.builder(
                      itemCount: filteredSections.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final section = filteredSections[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sectionTitle(section.title),
                            Column(
                              children: section.sections
                                  .map(
                                    (sectionItem) => carComponent(
                                      title: sectionItem.title,
                                      icon: sectionItem.icon,
                                      description: sectionItem.description,
                                      action: sectionItem.action,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
    child: Text(
      title,
      style: GoogleFonts.lato(
        color: ColorStyle.textBlackColor,
        fontSize: 16.0,
      ),
    ),
  );
}

Widget carComponent({
  required String icon,
  required String title,
  String? description,
  required void Function() action,
}) {
  return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: ColorStyle.containerBg,
                  borderRadius: BorderRadius.circular(8.0)),
              child: SvgPicture.asset(icon),
            ),
            gapW6,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    color: ColorStyle.textBlackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (description != null)
                  Text(
                    description,
                    style: GoogleFonts.lato(
                      color: ColorStyle.textBlackColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ));
}
