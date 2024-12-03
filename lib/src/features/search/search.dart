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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FormInputField(
                    // labelText: 'Email address',
                    hasBorderRadius: true,
                    placeholder: 'Ville, prix, type, disponibilité, emplacement...',
                    fillColor: ColorStyle.bgFieldGrey,
                    filled: true,
                    textInputType: TextInputType.text,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 18.0,
                    ),
                    // controller: authController.emailTextController,
                    // prefix: const Icon(FontAwesomeIcons.search),
                    fieldValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      return null;
                    },
                  ),
                  ListView.builder(
                    itemCount: _searchBarController.searchSections.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle(
                            _searchBarController.searchSections[index].title,
                          ),
                          // Convert the map result to a list of widgets using .toList()
                          Column(
                            children: _searchBarController
                                .searchSections[index].sections
                                .map(
                                  (section) => carComponent(
                                    title: section.title,
                                    icon: section.icon,
                                    description: section.description,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      );
                    },
                  ),
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
        // fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget carComponent({required String icon, title, String? description}) {
  return GestureDetector(
    onTap: () {
      Get.offAllNamed('/bottom_nav', arguments: {'activateSearchPlace': true});
    },
    child: Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      decoration: const BoxDecoration(
        // color: ColorStyle.carComponentBg,
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
              description != null
                  ? Text(
                      description.toString(),
                      style: GoogleFonts.lato(
                        color: ColorStyle.textBlackColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    ),
  );
}
