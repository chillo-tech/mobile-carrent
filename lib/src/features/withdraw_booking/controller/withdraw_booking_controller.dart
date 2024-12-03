import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BookingWithdrawController extends GetxController {
  
  RxList<XFile?> carImageFiles = RxList();
  RxBool hasErrorOnCarImage = false.obs;
}