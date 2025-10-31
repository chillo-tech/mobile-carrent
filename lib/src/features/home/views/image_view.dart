import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/theme.dart';

class ImageView extends StatelessWidget {
  ImageView({super.key});

  final List<dynamic> imageUrls =
      Get.arguments?['imageUrls'] ?? []; // Liste des images
  final int initialIndex =
      Get.arguments?['initialIndex'] ?? 0; // Index de l'image sélectionnée

  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        PageController(initialPage: initialIndex);

    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              panEnabled: true, // Désactiver le déplacement libre
              // boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.5,
              maxScale: 4.0,
              child: SizedBox.expand(
                // Permet de remplir tout l'écran
                child: FittedBox(
                  // Permet de garder l'image en plein écran en zoomant
                  fit: BoxFit.contain,
                  child: Image.network(
                    "https://files.mky-corp.fr/${imageUrls[index]}",
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
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
                          strokeWidth: 2.0,
                          // padding: EdgeInsets.symmetric(horizontal: 40.0),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
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
            ),
          );
        },
      ),
    );
  }
}
