import 'package:get/get.dart';

import '../../search/controllers/search_controller.dart';

class BottomNavController extends GetxController {
  final SearchBarController _searchBarController =
      Get.put(SearchBarController());
  RxInt selectedIndex = 0.obs;

  void onTabItemTapped(int index) {
    _searchBarController.isPlaceSearchActivated(false);
    print(index);
    selectedIndex(index);
  }
}
