import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodies_haven/models/food_model.dart';
import 'package:foodies_haven/utils/utils.dart';
import 'package:get/get.dart';

class OrderingController extends GetxController {
  RxInt count = 0.obs;
  RxString foodId = ''.obs;
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  void addToCart({
    required String id,
    required String category,
    required String desc,
    required String price,
    required String rating,
    required String time,
    required String title,
    required String url,
    required bool special,
  }) async {
    try {
      await firestore
          .collection('userData')
          .doc(auth.currentUser!.uid)
          .collection('myCart')
          .doc(id)
          .set(FoodModel(
            id: id,
            category: category,
            desc: desc,
            price: price,
            time: time,
            title: title,
            url: url,
            special: special,
            rating: rating,
          ).toMap());
    } catch (e) {
      Utils().showSnackBar('Error', 'can\'t add');
    }
  }

  void deleteItem({required String id}) async {
    try {
      await firestore
          .collection('userData')
          .doc(auth.currentUser!.uid)
          .collection('myCart')
          .doc(id)
          .delete();
    } catch (e) {
      Utils().showSnackBar('Error', e.toString());
    }
  }

  void addFavourite({
    required String id,
    required String category,
    required String desc,
    required String price,
    required String rating,
    required String time,
    required String title,
    required String url,
    required bool special,
    required bool isFavourite,
  }) async {
    try {
      await firestore
          .collection('userData')
          .doc(auth.currentUser!.uid)
          .collection('isFavourite')
          .doc(id)
          .set(
            FoodModel(
              id: id,
              category: category,
              desc: desc,
              price: price,
              rating: rating,
              time: time,
              title: title,
              url: url,
              special: special,
              isFavourite: isFavourite,
            ).toMap(),
          );
    } catch (e) {
      Utils().showSnackBar('Error', e.toString());
    }
  }

  void removeFavourite({
    required String id,
  }) {
    try {
      firestore
          .collection('userData')
          .doc(auth.currentUser!.uid)
          .collection('isFavourite')
          .doc(id)
          .delete();
    } catch (e) {
      Utils().showSnackBar('Error', e.toString());
    }
  }
}
