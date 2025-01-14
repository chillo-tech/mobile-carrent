import 'package:carrent/common/app_sizes.dart';
import 'package:carrent/helpers/assets.dart';
import 'package:carrent/models/car_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/common_fonctions.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/utility.dart';
import '../../create_post/controllers/post_controller.dart';

class PostDetails extends StatelessWidget {
  PostDetails({super.key});
  final CarResponse post = Get.arguments;
  PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> carDetails = [
      {
        'title': 'Marque',
        'value': post.make,
      },
      {
        'title': 'Modèle',
        'value': post.model,
      },
      {
        'title': 'Année',
        'value': post.year!,
      },
      {
        'title': 'Disponibilité',
        'value': formatDateRangewithYearFromStrings(
            post.startDisponibilityDate!, post.endDisponibilityDate!),
      },
      {
        'title': 'Prix par jour',
        'value': post.price!,
      },
      {
        'title': "Taux de l'état du véhicule",
        'value': post.condition!,
      },
      {
        'title': 'Type de carburant',
        'value': post.typeCarburant!,
      },
      {
        'title': 'Description',
        'value': post.description != null && post.description!.isNotEmpty
            ? post.description!
            : 'N/A',
        // 'value': post.description!,
      },
    ];
    return Scaffold(
      backgroundColor: ColorStyle.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            FontAwesomeIcons.xmark,
            color: ColorStyle.textBlackColor,
            size: 30.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/edit_post', arguments: post);
              },
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.pencil,
                    color: ColorStyle.textBlackColor,
                    size: 20.0,
                  ),
                  gapW8,
                  Text(
                    "Modifier l'annonce",
                    style: GoogleFonts.lato(
                      color: ColorStyle.fontColorLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post.make} ${post.model}',
                  style: GoogleFonts.lato(
                    color: ColorStyle.fontColorLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0,
                  ),
                ),
                gapH18,
                post.imagePathCar!.length > 1
                    ? GridView.custom(
                        shrinkWrap: true,
                        semanticChildCount: 3,
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            QuiltedGridTile(2, 2),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 2),
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                          childCount: post.imagePathCar?.length,
                          (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              // child: Image.network(
                              //   "https://files.chillo.fr/${post.imagePathCar![index]}",
                              //   fit: BoxFit.cover,
                              // ),
                              child: Image.network(
                                "https://files.chillo.fr/${post.imagePathCar![index]}",
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    // Retourne l'image une fois chargée
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: ColorStyle.lightPrimaryColor,
                                      backgroundColor: ColorStyle.grey,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
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
                              )),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.2,
                        // padding: const EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          // child: Image.network(
                          //   "https://files.chillo.fr/${post.imagePathCar![0]}",
                          //   fit: BoxFit.cover,
                          // ),
                          child: Image.network(
                            "https://files.chillo.fr/${post.imagePathCar![0]}",
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
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
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
                gapH32,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(
                    carDetails.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              carDetails[index]['title']!,
                              style: GoogleFonts.lato(
                                color: ColorStyle.opacGrey,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: carDetails[index]['title'] != 'Description' ||
                                    carDetails[index]['value']!.length < 30 ||
                                    carDetails[index]['value'] == "N/A"
                                ? 0
                                : 1,
                            child: Text(
                              carDetails[index]['value']!,
                              textAlign: TextAlign.end,
                              style: GoogleFonts.lato(
                                color: ColorStyle.fontColorLight,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                gapH16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Document du véhicule",
                        style: GoogleFonts.lato(
                          color: ColorStyle.opacGrey,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
//
                    GestureDetector(
                      onTap: () async {
                        await postController.downloadFile(post);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: ColorStyle.lightGreyColor1,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.download,
                              width: 15.0,
                              color: ColorStyle.fontColorLight,
                            ),
                            gapW6,
                            Text(
                              "Télécharger",
                              style: GoogleFonts.lato(
                                color: ColorStyle.fontColorLight,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                gapH16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Supprimer l'annonce",
                        style: GoogleFonts.lato(
                          color: ColorStyle.opacGrey,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(
                          Utility.simpleBinaryDialog(
                            title: "Supprimer l'annonce",
                            content:
                                "Voulez-vous vraiment supprimer cette annonce ?",
                            onBackPressed: () => Get.back(),
                            onContinuePressed: () async {
                              Get.back();
                              await postController.deleteMyPost(post.id);
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: ColorStyle.lightGreyColor1,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.trash,
                              width: 15.0,
                            ),
                            gapW6,
                            Text(
                              "Supprimer",
                              style: GoogleFonts.lato(
                                color: ColorStyle.lightAccentColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                gapH20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
