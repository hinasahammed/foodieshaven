import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodies_haven/res/components/meal_category_shimmer.dart';
import 'package:foodies_haven/view/food_details.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MealCategoryBottom extends StatefulWidget {
  final String category;
  const MealCategoryBottom({
    super.key,
    required this.category,
  });

  @override
  State<MealCategoryBottom> createState() => _MealCategoryBottomState();
}

class _MealCategoryBottomState extends State<MealCategoryBottom> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('food')
          .where('category', isEqualTo: widget.category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MealCategoryShimmer();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No data found!',
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
          );
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: .63,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final foodData = snapshot.data!.docs[index];
              return Stack(
                children: [
                  Container(
                    width: Get.width * .55,
                    height: Get.height * .6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    right: 8,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => FoodDetails(
                                title: foodData['title'],
                              ));
                        },
                        child: Container(
                          width: Get.width * .4,
                          height: Get.height * .22,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withOpacity(.15),
                                theme.colorScheme.primary.withOpacity(.1),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                foodData['title'][0].toString().toUpperCase() +
                                    foodData['title'].toString().substring(1),
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(5),
                              RatingBarIndicator(
                                rating:
                                    double.parse(foodData['rating'].toString()),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20,
                                direction: Axis.horizontal,
                              ),
                              const Gap(5),
                              Text(
                                foodData['time'],
                                style: theme.textTheme.labelSmall!.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: CachedNetworkImage(
                        width: Get.width * .3,
                        height: Get.height * .13,
                        imageUrl: foodData['url'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.black.withOpacity(0.2),
                          highlightColor: Colors.white54,
                          enabled: true,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
