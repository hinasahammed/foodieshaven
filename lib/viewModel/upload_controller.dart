import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:foodies_haven/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadController extends GetxController {
  Rx<File> selectedImage = File('').obs;
  Rx<String> networkImage = ''.obs;
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  RxBool loading = false.obs;

  Future pickImage() async {
    try {
      final imagePick = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (imagePick == null) {
        return Utils().showSnackBar('Pick image', 'You have to pick an image');
      }

      final imageTemp = File(imagePick.path);

      selectedImage.value = imageTemp;
    } on PlatformException catch (e) {
      return Utils().showSnackBar('Image Error', e.toString());
    }
  }

  Future uploadImage({
    required String uid,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('user_profiles/$uid');

      await ref.putFile(
          selectedImage.value, SettableMetadata(contentType: 'image/jpeg'));

      String downloadUrl = await ref.getDownloadURL();
      networkImage.value = downloadUrl;
    } catch (e) {
      return Utils().showSnackBar('uploading image', e.toString());
    }
  }

  Future authentication(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return Utils().showSnackBar('Authentication', e.toString());
    }
  }

  void updateEditedData(
    String uid,
    String userName,
  ) async {
    try {
      loading.value = true;
      await uploadImage(uid: uid);
      await firestore.collection('userData').doc(uid).update(
        {
          'userName': userName,
          'imageUrl': networkImage.value,
        },
      ).then((value) => Get.back());
      loading.value = false;
    } catch (e) {
      Utils().showSnackBar("Error", e.toString());
    }
  }
}
