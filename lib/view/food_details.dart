import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodies_haven/res/components/meal_category_shimmer.dart';
import 'package:foodies_haven/viewModel/ordering_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class FoodDetails extends StatefulWidget {
  final String title;
  const FoodDetails({
    super.key,
    required this.title,
  });

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  final orderController = Get.put(OrderingController());
  final firestore = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('food')
            .where('title', isEqualTo: widget.title)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MealCategoryShimmer();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              snapshot.data == null) {
            return Center(
              child: Text(
                'No data found!',
                style: theme.textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return Column(
              children: snapshot.data!.docs.map((foodData) {
                return Expanded(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: Get.width,
                        height: Get.height,
                      ),
                      Positioned(
                        top: 0,
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            width: Get.width,
                            height: Get.height * .4,
                            imageUrl: foodData['url'],
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.white54,
                              enabled: true,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 8,
                              sigmaY: 8,
                            ),
                            child: Container(
                              width: Get.width,
                              height: Get.height * .65,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer
                                    .withOpacity(.25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(.2),
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          size: 25,
                                        ),
                                        color: Colors.white,
                                      ),
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('userData')
                                            .doc(auth.currentUser!.uid)
                                            .collection('isFavourite')
                                            .where('id',
                                                isEqualTo: foodData['id'])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.data == null) {
                                            return const Text('Error');
                                          }
                                          return IconButton(
                                            onPressed: () {
                                              snapshot.data!.docs.isNotEmpty
                                                  ? orderController
                                                      .removeFavourite(
                                                          id: foodData['id'])
                                                  : orderController
                                                      .addFavourite(
                                                      id: foodData['id'],
                                                      category:
                                                          foodData['category'],
                                                      desc: foodData['desc'],
                                                      price: foodData['price'],
                                                      rating:
                                                          foodData['rating'],
                                                      time: foodData['time'],
                                                      title: foodData['title'],
                                                      url: foodData['url'],
                                                      special:
                                                          foodData['special'],
                                                      isFavourite: true,
                                                    );
                                            },
                                            icon: Icon(
                                              snapshot.data!.docs.isNotEmpty
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,
                                              size: 25,
                                            ),
                                            color:
                                                snapshot.data!.docs.isNotEmpty
                                                    ? Colors.red
                                                    : Colors.white,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: Get.width * .6,
                                        child: Text(
                                          foodData['title'][0].toUpperCase() +
                                              foodData['title'].substring(1),
                                          style: theme.textTheme.titleLarge!
                                              .copyWith(
                                            color:
                                                theme.colorScheme.onBackground,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Text(
                                        '₹${foodData['price']}'.toString(),
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    foodData['category'].toString(),
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        foodData['time'].toString(),
                                        style: theme.textTheme.labelMedium!
                                            .copyWith(
                                          color: theme.colorScheme.secondary,
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
                                        itemSize: 25,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  ),
                                  const Gap(20),
                                  Text(
                                    'Discription',
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      color: theme.colorScheme.onBackground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    foodData['desc'][0].toUpperCase() +
                                        foodData['desc'].substring(1),
                                    style: theme.textTheme.titleSmall!.copyWith(
                                      color: theme.colorScheme.secondary,
                                    ),
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: Get.width * .15,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(1),
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                          ),
                                          onPressed: () {
                                            if (orderController.count.value >
                                                0) {
                                              orderController.count.value--;
                                            }
                                          },
                                          child: Text(
                                            '-',
                                            style: theme.textTheme.titleLarge!
                                                .copyWith(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(15),
                                      Obx(
                                        () => Text(
                                          orderController.count.value
                                              .toString(),
                                          style: theme.textTheme.titleLarge!
                                              .copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Gap(15),
                                      SizedBox(
                                        width: Get.width * .15,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(1),
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                          ),
                                          onPressed: () {
                                            orderController.count.value++;
                                          },
                                          child: Text(
                                            '+',
                                            style: theme.textTheme.titleLarge!
                                                .copyWith(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            backgroundColor: theme
                                                .colorScheme.primaryContainer,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            'Order food',
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(
                                              color: theme.colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            backgroundColor: theme
                                                .colorScheme.secondaryContainer,
                                          ),
                                          onPressed: () {
                                            orderController.addToCart(
                                              id: const Uuid().v4(),
                                              category: foodData['category'],
                                              desc: foodData['desc'],
                                              price: foodData['price'],
                                              rating:
                                                  foodData['rating'].toString(),
                                              time: foodData['time'],
                                              title: foodData['title'],
                                              url: foodData['url'],
                                              special: foodData['special'],
                                            );
                                          },
                                          child: Text(
                                            'Add to cart',
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(
                                              color: theme.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                        ),
                                      ])
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    ));
  }
}
