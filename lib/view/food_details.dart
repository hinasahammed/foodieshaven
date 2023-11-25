import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/food_details_bottom_card.dart';
import 'package:foodies_haven/res/components/food_details_image.dart';
import 'package:foodies_haven/res/components/food_details_shimmer.dart';
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
        body: SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('food')
            .where('title', isEqualTo: widget.title)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const FoodDetailsShimmer();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              snapshot.data == null) {
            return Center(
              child: Text(
                'The food not found!',
                style: theme.textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return Column(
              children: snapshot.data!.docs.map(
                (foodData) {
                  return Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: Get.width,
                          height: Get.height,
                        ),
                        Positioned(
                          top: 0,
                          child: FoodDetailsImage(
                            imageUrl: foodData['url'],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: FoodDetailsBottomCard(
                            id: foodData['id'],
                            category: foodData['category'],
                            desc: foodData['desc'],
                            price: foodData['price'],
                            rating: foodData['rating'],
                            time: foodData['time'],
                            title: foodData['title'],
                            url: foodData['url'],
                            special: foodData['special'],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            );
          }
        },
      ),
    ));
  }
}
