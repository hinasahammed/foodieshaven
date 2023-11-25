import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodies_haven/res/components/shimmer_list.dart';
import 'package:foodies_haven/viewModel/cart_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class MyCartView extends StatefulWidget {
  const MyCartView({super.key});

  @override
  State<MyCartView> createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  final auth = FirebaseAuth.instance;
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My cart'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userData')
            .doc(auth.currentUser!.uid)
            .collection('myCart')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => const ShimmerList());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Lottie.asset(
                'assets/animation/no_cart_item.json',
                repeat: false,
              ),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              children: snapshot.data!.docs.map(
                (foodData) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: theme.colorScheme.onError,
                            ),
                            Text(
                              'Move to delete',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onError,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Confirm',
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to delete?',
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
                                  Get.back();
                                  cartController.deleteCartItem(
                                    id: foodData['id'],
                                  );
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      key: ValueKey(foodData),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: Get.width,
                        height: Get.height * .15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    width: Get.width * .25,
                                    height: Get.height * .13,
                                    imageUrl: foodData['url'],
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.black.withOpacity(0.2),
                                      highlightColor: Colors.white54,
                                      enabled: true,
                                      child: Container(
                                        width: Get.width,
                                        height: Get.height * .14,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                const Gap(15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: Get.width * .4,
                                      child: Text(
                                        foodData['title'][0]
                                                .toString()
                                                .toUpperCase() +
                                            foodData['title']
                                                .toString()
                                                .substring(1),
                                        style:
                                            theme.textTheme.bodyLarge!.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      rating: double.parse(
                                          foodData['rating'].toString()),
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20,
                                      direction: Axis.horizontal,
                                    ),
                                    Text(
                                      '(50)Reviews',
                                      style:
                                          theme.textTheme.labelSmall!.copyWith(
                                        color: Colors.white54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                '₹${foodData['price']}',
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            );
          }
        },
      ),
    );
  }
}
