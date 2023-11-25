import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodies_haven/models/food_model.dart';
import 'package:foodies_haven/utils/utils.dart';
import 'package:get/get.dart';

class CartController extends GetxController{
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
          ).toMap())
          .then(
            (value) => Utils().showSnackBar('Added', 'Item added to cart'),
          );
    } catch (e) {
      Utils().showSnackBar('Error', 'can\'t add');
    }
  }

  void deleteCartItem({required String id}) async {
    try {
      await firestore
          .collection('userData')
          .doc(auth.currentUser!.uid)
          .collection('myCart')
          .doc(id)
          .delete()
          .then(
            (value) =>
                Utils().showSnackBar('Deleted', 'Item deleted from cart'),
          );
    } catch (e) {
      Utils().showSnackBar('Error', e.toString());
    }
  }

}