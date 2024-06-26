import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodies_haven/res/components/shimmer_list.dart';
import 'package:foodies_haven/view/food_details.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AllMeals extends StatefulWidget {
  const AllMeals({super.key});

  @override
  State<AllMeals> createState() => _AllMealsState();
}

class _AllMealsState extends State<AllMeals> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Meals'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('food').snapshots(),
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
              child: Text(
                'No data found!',
                style: theme.textTheme.titleLarge!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
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
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          () => FoodDetails(
                            title: foodData['title'],
                          ),
                        );
                      },
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
                                          color: theme.colorScheme.onSurface,
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
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(.4),
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
