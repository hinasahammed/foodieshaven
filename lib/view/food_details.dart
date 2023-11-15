import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/meal_category_shimmer.dart';
import 'package:get/get.dart';

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
        appBar: AppBar( 
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_outline),
            ),
          ],
        ),
        body: StreamBuilder(
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
                          bottom: 0,
                          child: Container(
                            width: Get.width,
                            height: Get.height * .52,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                )),
                            child: const Column(
                              children: [],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Image.network(
                            foodData['url'],
                            fit: BoxFit.fill,
                            width: Get.width,
                            height: Get.height * .35,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          },
        ));
  }
}
