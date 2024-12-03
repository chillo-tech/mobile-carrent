import 'package:carrent/controllers/error_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/common_fonctions.dart';
import '../../../../common/storage_constants.dart';
import '../../../../helpers/assets.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/utility.dart';
import '../../bookings/views/bookings.dart';
import '../../home/views/home.dart';
import '../../my_posts/views/my_posts.dart';
import '../../search/controllers/search_controller.dart';
import '../../settings/views/settings.dart';
import '../controllers/bottom_nav_controller.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});
  final BottomNavController _bottomNavController =
      Get.put(BottomNavController());

  List<Widget> pages = [
    Home(),
    const Bookings(),
    MyPosts(),
    Settings(),
  ];
  final SearchBarController _searchBarController =
      Get.put(SearchBarController());

  @override
  Widget build(BuildContext context) {
    print(_searchBarController.isPlaceSearchActivated);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorStyle.lightWhiteBackground,
          appBar: !_searchBarController.isPlaceSearchActivated.value
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  // leading: GestureDetector(
                  //   onTap: () {
                  //     _bottomNavController.logoutUser("Deconnexion...");
                  //   },
                  //   child: const Icon(
                  //     FontAwesomeIcons.signOutAlt,
                  //     color: ColorStyle.textBlackColor,
                  //     size: 20.0,
                  //   ),
                  // ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/notification');
                        },
                        child: SvgPicture.asset(
                          Assets.bell,
                          height: 20.0,
                        ),
                      ),
                    )
                  ],
                )
              : null,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Obx(() {
                      return pages[_bottomNavController.selectedIndex.value];
                    }),
                  ),
                ),
                Obx(() {
                  return _searchBarController.isPlaceSearchActivated.value
                      ? topSheet(context)
                      : const SizedBox();
                }),
              ],
            ),
          ),
          floatingActionButton: Obx(() {
            return _bottomNavController.selectedIndex.value == 2
                ? FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    onPressed: () {
                      final loggedIn =
                          GetStorage().read(StorageConstants.loggedIn);
                      if (loggedIn != null && loggedIn) {
                        Get.toNamed('/create_post');
                      } else {
                        Get.dialog(
                          Utility.simpleBinaryDialog(
                            title: "Connexion",
                            content:
                                "Vous devez vous connecter pour publier une annonce",
                            onBackPressed: () => Get.back(),
                            onContinuePressed: () => Get.offAllNamed('/login'),
                          ),
                        );
                      }
                    },
                    backgroundColor: ColorStyle.lightPrimaryColor,
                    child: const Icon(
                      FontAwesomeIcons.plus,
                      color: ColorStyle.lightWhiteBackground,
                    ),
                  )
                : const SizedBox();
          }),
          bottomNavigationBar: Obx(() {
            return Container(
              decoration: const BoxDecoration(),
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      Assets.search,
                      // width: 50.0,
                      height: 25.0,
                      // colorFilter: ColorFilter.mode(
                      //     _bottomNavController.selectedIndex.value == 0
                      //         ? ColorStyle.lightPrimaryColor
                      //         : ColorStyle.lightPrimaryColor, BlendMode.srcIn),
                      color: _bottomNavController.selectedIndex.value == 0
                          ? ColorStyle.lightPrimaryColor
                          : ColorStyle.unselectedTabColor,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      Assets.car,
                      height: 25.0,
                      color: _bottomNavController.selectedIndex.value == 1
                          ? ColorStyle.lightPrimaryColor
                          : ColorStyle.unselectedTabColor,
                    ),
                    label: 'Reservations',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      Assets.alert,
                      height: 25.0,
                      color: _bottomNavController.selectedIndex.value == 2
                          ? ColorStyle.lightPrimaryColor
                          : ColorStyle.unselectedTabColor,
                    ),
                    label: 'Publications',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      Assets.cogs,
                      height: 25.0,
                      color: _bottomNavController.selectedIndex.value == 3
                          ? ColorStyle.lightPrimaryColor
                          : ColorStyle.unselectedTabColor,
                    ),
                    label: 'Settings',
                  ),
                ],
                currentIndex: _bottomNavController.selectedIndex.value,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: ColorStyle.unselectedTabColor,
                selectedItemColor: ColorStyle.lightPrimaryColor,
                selectedLabelStyle: GoogleFonts.lato(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.lato(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: ColorStyle.grey,
                onTap: _bottomNavController.onTabItemTapped,
              ),
            );
          }),
        ),
      ],
    );
  }
}
