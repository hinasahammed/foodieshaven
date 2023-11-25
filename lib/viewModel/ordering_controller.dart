import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/custom_button.dart';
import 'package:foodies_haven/utils/utils.dart';
import 'package:foodies_haven/view/my_order.dart';
import 'package:foodies_haven/view/tab_bar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OrderingController extends GetxController {
  RxInt count = 1.obs;
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  void addToUserOrder({
    required String id,
    required String name,
    required String url,
    required String count,
    required String tableNo,
    required String timeTake,
    required String date,
    required String total,
    required ThemeData theme,
    required BuildContext context,
  }) async {
    try {
      await firestore
          .collection('userData')
          .doc(auth.currentUser!.uid)
          .collection('userOrder')
          .doc()
          .set(
            {
              'Id': id,
              'Name': name,
              'url': url,
              'Count': count,
              'date': date,
              'tableNo': tableNo,
              'timeTake': timeTake,
              'Total': total,
            },
          )
          .then((value) => Get.back())
          .then((value) =>
              Utils().showSnackBar('success', 'Ordered successfully'))
          .then((value) => showSuccessDialog(theme, context));
    } catch (e) {
      Utils().showSnackBar('Error', e.toString());
    }
  }

  void showConfirmDailog({
    required String id,
    required String name,
    required String url,
    required String count,
    required String tableNo,
    required String timeTake,
    required String date,
    required String total,
    required ThemeData theme,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm your Order',
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        content: Text(
          'Are you sure you want to order?',
          style: theme.textTheme.titleSmall!.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addToUserOrder(
                id: id,
                name: name,
                url: url,
                date: date,
                count: count,
                timeTake: timeTake,
                tableNo: tableNo,
                total: total,
                context: context,
                theme: theme,
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(ThemeData theme, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Lottie.asset(
              'assets/animation/success.json',
              repeat: false,
            ),
            Text(
              'Your order is successfully.',
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: SizedBox(
          height: Get.height * .23,
          child: Column(
            children: [
              Text(
                'You can find the delivery in "My order" session',
                style: theme.textTheme.titleSmall!.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              CustomButton(
                text: 'Continue Shopping',
                onPressed: () {
                  Get.to(() => const TabBarControlView());
                },
                loading: false,
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const MyOrderView());
                },
                child: const Text('Go to My order'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
