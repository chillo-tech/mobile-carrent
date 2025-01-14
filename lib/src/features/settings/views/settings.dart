import 'package:carrent/src/features/booking/controllers/booking_controller.dart';
import 'package:carrent/src/features/create_post/controllers/post_controller.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/common_fonctions.dart';
import '../../../../common/storage_constants.dart';
import '../../../../controllers/error_controller.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../controllers/settings_controller.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/app_sizes.dart';
import '../../../../controllers/user_controller.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SettingsController _settingsController = Get.put(SettingsController());

  final UserController _userController = Get.put(UserController());

  final PostController _postController =
      Get.put(PostController(launchInitState: false));

  final BookingsController _bookingsController = Get.put(BookingsController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await _userController.retreiveUserData();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> settingsLinks = [
      {
        'title': 'Mon Compte',
        'description': 'Apportez des modifications à votre compte',
        'icon': 'assets/icons/user.svg',
        'route': '/update_profile',
      },
      {
        'title': 'Notifications',
        'description': 'Activer les notifications push',
        'icon': 'assets/icons/lock.svg',
        'route': '', // '/notifications',
      },
      {
        'title': 'Déconnexion',
        'description': 'Se déconnecter du compte',
        'icon': 'assets/icons/logout.svg',
        'route': '/logout',
      },
      {
        'title': 'Gérer un litige',
        'description': 'Gérer un litige lié à une réservation',
        'icon': 'assets/icons/alert_primary.svg',
        'route': '/conflit', // '/notifications',
      },
    ];

    List<Map<String, String>> settingsLinksPlus = [
      {
        'title': 'Aide et Support',
        'icon': 'assets/icons/help_message.svg',
        'route': '/help',
      },
      {
        'title': 'À propos de l\'application',
        'icon': 'assets/icons/about.svg',
        'route': '/about',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paramètres',
          style: GoogleFonts.lato(
            color: ColorStyle.textBlackColor,
            fontWeight: FontWeight.w700,
            fontSize: 24.0,
          ),
        ),
        gapH10,
        Container(
          decoration: BoxDecoration(
              color: ColorStyle.lightPrimaryColor,
              borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: const BoxDecoration(
                            color: ColorStyle.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            _userController.currentuser != null &&
                                    _userController
                                        .currentuser!.completeName.isNotEmpty
                                ? _userController.currentuser!.completeName[0]
                                : "G",
                            style: GoogleFonts.lato(
                              color: ColorStyle.textBlackColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                color: ColorStyle.white,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/pencil.svg',
                                fit: BoxFit.cover,
                              ),
                            ))
                      ],
                    ),
                    gapW10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userController.currentuser != null &&
                                  _userController
                                      .currentuser!.completeName.isNotEmpty
                              ? _userController.currentuser!.completeName
                              : "Guest",
                          style: GoogleFonts.poppins(
                            color: ColorStyle.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          _userController.currentuser != null &&
                                  (_userController.currentuser!.email != null &&
                                      _userController
                                          .currentuser!.email!.isNotEmpty)
                              ? _userController.currentuser!.email!
                              : _userController.currentuser != null &&
                                      (_userController
                                                  .currentuser!.phoneNumber !=
                                              null &&
                                          _userController.currentuser!
                                              .phoneNumber.isNotEmpty)
                                  ? _userController.currentuser!.phoneNumber
                                  : "guest@guest.guest",
                          style: GoogleFonts.poppins(
                            color: ColorStyle.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/icons/flower.svg',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        gapH10,
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              border: Border.all(color: ColorStyle.lightGreyColor)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Annonces',
                    style: GoogleFonts.lato(
                      color: ColorStyle.textBlackColor,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    _postController.myCars.length.toString(),
                    style: GoogleFonts.lato(
                      color: ColorStyle.textBlackColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Réservations',
                    style: GoogleFonts.lato(
                      color: ColorStyle.textBlackColor,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    _bookingsController.myBookings.length.toString(),
                    style: GoogleFonts.lato(
                      color: ColorStyle.textBlackColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        gapH10,
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: ColorStyle.lightGreyColor)),
          child: ListView.builder(
              itemCount: settingsLinks.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return settingsLisks(
                  settingsLinks[index]['description']!,
                  icon: settingsLinks[index]['icon']!,
                  title: settingsLinks[index]['title']!,
                  route: settingsLinks[index]['route']!,
                  isEnd: index == (settingsLinks.length - 1),
                );
              }),
        ),
        gapH10,
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: ColorStyle.lightGreyColor)),
          child: ListView.builder(
              itemCount: settingsLinksPlus.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return settingsLisks(
                  '',
                  icon: settingsLinksPlus[index]['icon']!,
                  title: settingsLinksPlus[index]['title']!,
                  route: settingsLinksPlus[index]['route']!,
                  isEnd: index == (settingsLinksPlus.length - 1),
                );
              }),
        )
      ],
    );
  }

  Widget settingsLisks(String? description,
      {required String icon, title, route, required bool isEnd}) {
    return InkWell(
      onTap: () {
        if (route == '/logout') {
          final loggedIn = GetStorage().read(StorageConstants.loggedIn);
          if (loggedIn != null && loggedIn) {
            Get.dialog(
              Utility.simpleBinaryDialog(
                title: "Déconnexion",
                content: "Voulez-vous vraiment vous déconnecter ?",
                onBackPressed: () => Get.back(),
                onContinuePressed: () =>
                    _settingsController.logoutUser("Déconnexion..."),
              ),
            );
          } else {
            Get.dialog(
              Utility.simpleBinaryDialog(
                title: "Connexion",
                content:
                    "Vous devez vous connecter pour acceder à cette fonctionnalité",
                onBackPressed: () => Get.back(),
                onContinuePressed: () => Get.offAllNamed('/login'),
              ),
            );
          }
        } else if (route == '/conflit') {
          Get.bottomSheet(
            conflictSheet(
                bookings: _bookingsController.myBookings.where((booking) {
              return booking.withdrawStatus != "En Litige";
            }).toList()),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        } else if (route == '/update_profile') {
          final loggedIn = GetStorage().read(StorageConstants.loggedIn);
          if (loggedIn != null && loggedIn) {
            Get.toNamed('/update_profile');
          } else {
            Get.dialog(
              Utility.simpleBinaryDialog(
                title: "Profile",
                content:
                    "Vous devez vous connecter pour acceder à cette fonctionnalité",
                onBackPressed: () => Get.back(),
                onContinuePressed: () => Get.offAllNamed('/login'),
              ),
            );
          }
        } else if (route.isNotEmpty) {
          Get.toNamed(route);
        }
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: ColorStyle.lightPrimaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      icon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  gapW10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: ColorStyle.textBlackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                      if (description != null && description.isNotEmpty)
                        Text(
                          description,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFABABAB),
                            fontSize: 12.0,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (title == 'Notifications')
                Obx(() {
                  return Switch(
                      inactiveTrackColor: const Color(0xFFABABAB),
                      inactiveThumbColor: ColorStyle.white,
                      activeColor: ColorStyle.white,
                      value: _settingsController.isNotificationsEnable.value,
                      onChanged: (bool? value) {
                        _settingsController.isNotificationsEnable(
                            !_settingsController.isNotificationsEnable.value);
                      });
                })
            ],
          ),
          if (!isEnd) gapH16,
        ],
      ),
    );
  }
}
