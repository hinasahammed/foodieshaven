import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodies_haven/models/user_model.dart';
import 'package:foodies_haven/utils/utils.dart';
import 'package:foodies_haven/view/login.dart';
import 'package:foodies_haven/viewModel/upload_controller.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  RxBool loading = false.obs;

  final uploadController = Get.put(UploadController());

  Future createAccount(
    String email,
    String userName,
    String password,
    String createdAt,
  ) async {
    loading.value = true;
    await uploadController.authentication(email, password);

    await uploadController.uploadImage(
      uid: _auth.currentUser!.uid,
      userName: userName,
    );

    try {
      await firestore
          .collection('userData')
          .doc(_auth.currentUser!.uid)
          .set(UserModel(
            userName: userName,
            email: email,
            password: password,
            imageUrl: uploadController.networkImage.value,
            uid: _auth.currentUser!.uid,
            createdAt: createdAt,
          ).toMap())
          .then((value) => Utils()
              .showSnackBar('Successfull', 'Account created successfully'))
          .then(
            (value) => Get.to(
              const LoginView(),
            ),
          );
      loading.value = false;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          //Thrown if the email address is not valid.
          Utils().showSnackBar('Error', 'email address is not valid');
        case "user-disabled":
          //Thrown if the user corresponding to the given email has been disabled.
          Utils().showSnackBar('Error', 'user-disabled');
        case "user-not-found":
          //Thrown if there is no user corresponding to the given email.
          Utils().showSnackBar('Error', 'user not found');
        case "wrong-password":
          Utils().showSnackBar('Error', 'Wrong password');
        //Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set.
        default:
          Utils().showSnackBar('Error', 'An undefined Error happened.');
      }
    }
  }
}
