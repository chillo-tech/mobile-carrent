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
import '../../create_post/controllers/post_controller.dart';
import '../../widgets/primary_button.dart';

class MyPosts extends StatefulWidget {
  MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  final PostController _postController = Get.put(PostController());

  @override
  initState() {
    Future.delayed(Duration.zero, () {
      final loggedIn = GetStorage().read(StorageConstants.loggedIn);
      if (loggedIn != null && loggedIn) {
        _postController.getMyPosts(launchLoader: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_postController.myCars);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Toutes les annonces",
            style: GoogleFonts.lato(
              color: ColorStyle.fontColorLight,
              fontWeight: FontWeight.w700,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Obx(() {
            return _postController.myCars.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _postController.myCars.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/post_details',
                              arguments: _postController.myCars[index]);
                        },
                        child: postComponent(
                          context: context,
                          status: 'En révision',
                          // status: _postController.myCars[index]['status'],
                          title:
                              '${_postController.myCars[index].make} ${_postController.myCars[index].model}',
                          image:
                              "https://files.chillo.fr/${_postController.myCars[index].imagePathCar![0]}",
                          // description: _postController.myCars[index].description ??
                          description: _postController
                                          .myCars[index].description !=
                                      null &&
                                  _postController
                                          .myCars[index].description!.length >
                                      100
                              ? '${_postController.myCars[index].description!.substring(0, 100)}...'
                              : _postController.myCars[index].description ?? "",
                        ),
                      );
                    })
                : Column(
                    children: [
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
                            isRoundedBorder: true,
                            title: 'Parcourir les voitures',
                            onPressed: () {
                              Get.offAllNamed('/bottom_nav');
                            },
                          )
                        ],
                      )
                    ],
                  );
          })
        ],
      ),
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

  Widget carComponent({required String title, image, rating, commands, price}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      decoration: const BoxDecoration(
        color: ColorStyle.carComponentBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              title,
              style: GoogleFonts.lato(
                color: ColorStyle.fontColorLight,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Text(
                  "$rating",
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontSize: 14.0,
                  ),
                ),
                SvgPicture.asset(Assets.star),
                Text(
                  "($commands commandes)",
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontSize: 14.0,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "$price FCFA /jour",
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget postComponent(
      {required BuildContext context,
      required String status,
      title,
      description,
      image}) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(left: 7.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: ColorStyle.hintColor.withOpacity(0.11)),
            // height: 180.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: BoxDecoration(
                              color: Color(0xFFE8E8E8),
                              border: Border.all(color: ColorStyle.white),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                getPostIconByStatus(status),
                                size: 17.0,
                                color: getPostColorByStatus(status),
                              ),
                              const SizedBox(width: 7.0),
                              Text(status,
                                  style: GoogleFonts.lato(
                                    color: getPostColorByStatus(status),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.0,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 7.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.lato(
                              color: ColorStyle.fontColorLight,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 7.0),
                          Text(
                            description,
                            style: GoogleFonts.lato(
                              color: ColorStyle.fontColorLight,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Voir les détails',
                                style: GoogleFonts.lato(
                                  color: ColorStyle.fontColorLight,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Icon(FontAwesomeIcons.arrowRight)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3.7,
                    height: 180.0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0)),
                      // child: Image.asset(
                      //   image,
                      //   fit: BoxFit.cover,
                      // ),
                      // child: Image.network(
                      //   image,
                      //   fit: BoxFit.cover,
                      // ),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            // Retourne l'image une fois chargée
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorStyle.lightPrimaryColor,
                              backgroundColor: ColorStyle.grey,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // Retourne un placeholder ou un widget d'erreur si l'image échoue
                          return Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50.0,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            )),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
