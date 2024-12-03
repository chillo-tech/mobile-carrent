import '../../../../common/app_sizes.dart';
import '../../create_post/controllers/post_controller.dart';
import '../controllers/home_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../common/common_fonctions.dart';
import '../../../../helpers/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/theme.dart';
import '../../search/controllers/search_controller.dart';
import '../../widgets/form_input_field.dart';
import '../../widgets/primary_button.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RangeValues _currentRangeValues = const RangeValues(1000, 20000);
  final HomeController homeController = Get.put(HomeController());
  final PostController postController = Get.put(PostController());
  @override
  initState() {
    Future.delayed(Duration.zero, () {
      homeController.getCars();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  "Trouvez le véhicule qu'il vous faut",
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              GestureDetector(
                onTap: () => Get.toNamed('/search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorStyle.borderColor),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.search,
                        color: ColorStyle.textBlackColor,
                        size: 20.0,
                      ),
                      // SvgPicture.asset(Assets.search),
                      const SizedBox(width: 10.0),
                      Text(
                        "Rechercher un véhicule",
                        style: GoogleFonts.lato(
                          color: ColorStyle.greyColor,
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sectionTitle('Vu récemment'),
              Obx(() {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: homeController.cars.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      print(homeController.cars);
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/car_details',
                                  arguments: homeController.cars[index]);
                            },
                            child: carComponent(
                              title: homeController.cars[index].make,
                              image:
                                  "https://files.chillo.fr/${homeController.cars[index].imagePathCar![0]}",
                              rating: 4.95,
                              commands: 120,
                              price: homeController.cars[index].price,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      );
                    });
              }),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 350,
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                            child: Image.asset(Assets.car3)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                              child: Image.asset(Assets.car4)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Column(
                      children: [
                        Text(
                          "Louez, Roulez, Retournez – Aussi simple que ça!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: ColorStyle.fontColorLight,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          "Location de voiture simplifiée à portée de main, pour tout voyage, grand ou petit.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: ColorStyle.greyColor,
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  PrimaryButton(
                    title: 'Parcourir les voitures',
                    onPressed: () {},
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.lato(
          color: ColorStyle.textBlackColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
