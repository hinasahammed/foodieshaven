import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodies_haven/utils/utils.dart';
import 'package:foodies_haven/view/tab_bar.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  final _auth = FirebaseAuth.instance;
  RxBool loading = false.obs;

  Future signin(String email, String password) async {
    loading.value = true;
    try {
      await _auth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then(
              (value) => Utils().showSnackBar('Success', 'Login Successfully'))
          .then(
            (value) => Get.offAll(
              const TabBarControlView(),
            ),
          );
      loading.value = false;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        return Utils().showSnackBar('Error', 'email address is not valid');
      }
      if (error.code == 'user-disabled') {
        return Utils().showSnackBar('Error', 'email has been disabled');
      }
      if (error.code == 'user-not-found') {
        return Utils().showSnackBar(
            'Error', 'there is no user corresponding to the given email');
      }
      if (error.code == 'wrong-password') {
        return Utils().showSnackBar('Error', 'password is invalid');
      }
      return Utils().showSnackBar('Error', error.message.toString());
    }
  }
}
