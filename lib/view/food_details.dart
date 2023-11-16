import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodies_haven/res/components/meal_category_shimmer.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

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
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.grey.shade100,
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
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.favorite_outline,
                                          size: 25,
                                        ),
                                        color: Colors.white,
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
                                  const Gap(20),
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
                                          onPressed: () {},
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
                                      Text(
                                        '0',
                                        style: theme.textTheme.titleLarge!
                                            .copyWith(
                                          color: Colors.white,
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
                                          onPressed: () {},
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
                                  )
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
