import 'package:carrent/src/features/notifications/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/app_sizes.dart';
import '../../../../helpers/assets.dart';
import '../../../../models/notification_response.dart';
import '../../../../theme/theme.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsController notificationsController =
      Get.put(NotificationsController());

  @override
  void initState() {
    notificationsController.storedNotifications.clear();
    notificationsController.storedNotifications
        .addAll(notificationsController.loadNotifications());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorStyle.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () {
              notificationsController.saveNotifications();
              Get.back();
            },
            child: const Icon(
              FontAwesomeIcons.arrowLeft,
              color: ColorStyle.textBlackColor,
              size: 20.0,
            ),
          ),
          title: Text(
            "Accueil",
            style: GoogleFonts.lato(
              color: ColorStyle.textBlackColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Notications",
                    style: GoogleFonts.lato(
                      color: ColorStyle.fontColorLight,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  gapH20,
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: notificationsController.notifications.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      return notificationItem(
                          notification:
                              notificationsController.notifications[index]);
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget notificationItem({required LocalNotificationResponse notification}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              notification.title == 'Message de bienvenue'
                  ? Assets.smile_star
                  : Assets.car_alert,
              fit: BoxFit.cover,
            ),
            gapW12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: GoogleFonts.lato(
                    color: ColorStyle.textBlackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                if (notification.description.isNotEmpty)
                  Text(
                    notification.description,
                    style: GoogleFonts.lato(
                      color: const Color(0xFFABABAB),
                      fontSize: 14.0,
                    ),
                  ),
                if (notification.date.isNotEmpty)
                  Text(
                    notification.date.split(' ').last,
                    style: GoogleFonts.lato(
                      color: const Color(0xFFABABAB),
                      fontSize: 14.0,
                    ),
                  ),
              ],
            ),
          ],
        ),
        Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
            color: ColorStyle.lightPrimaryColor,
            shape: BoxShape.circle,
          ),
        ),
        // Obx(() {
        //   return
        //       // notificationsController.storedNotifications.firstWhere(
        //       //             (element) => element.id == notification.id).id !=
        //       //         null
        //       //     ?
        //       Container(
        //     height: 10.0,
        //     width: 10.0,
        //     decoration: BoxDecoration(
        //       color: ColorStyle.lightPrimaryColor,
        //       shape: BoxShape.circle,
        //     ),
        //   );
        //   // : SizedBox();
        // })
      ],
    );
  }
}
