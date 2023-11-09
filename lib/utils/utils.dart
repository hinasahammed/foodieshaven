import 'package:get/get.dart';

class Utils {
  void showSnackBar(String title, String message) {
    Get.closeAllSnackbars();
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2));
  }

  
}
