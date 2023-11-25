import 'package:get/get.dart';

class GetStartedController extends GetxController {
  RxInt count = 0.obs;
  

  void updateCount() {
    count.value++;
  }

  void decrementCount() {
    count.value--;
  }
}
