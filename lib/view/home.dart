import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/home_top_card.dart';
import 'package:foodies_haven/res/components/meal_category.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final auth = FirebaseAuth.instance;

  final List<String> imageList = [
    "assets/images/burger_cl2.png",
    "assets/images/burger_mid.png",
    "assets/images/burger_op.png",
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('userData')
              .where("uid", isEqualTo: auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: snapshot.data!.docs.map(
                  (userData) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Hi,',
                                      style:
                                          theme.textTheme.bodyLarge!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      userData['userName'][0]
                                              .toString()
                                              .toUpperCase() +
                                          userData['userName']
                                              .toString()
                                              .substring(1),
                                      style:
                                          theme.textTheme.bodyLarge!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Ready to order food?',
                                  style: theme.textTheme.labelMedium!.copyWith(
                                    color: Colors.white54,
                                  ),
                                )
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                width: Get.width * .13,
                                height: Get.height * .06,
                                imageUrl: userData['imageUrl'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey.shade200,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ],
                        ),
                        const Gap(30),
                        CarouselSlider.builder(
                          itemCount: imageList.length,
                          itemBuilder: (context, index, realIndex) {
                            return HomeTopCard(
                              image: imageList[index],
                            );
                          },
                          options: CarouselOptions(
                            aspectRatio: 16 /
                                9, // You can adjust this aspect ratio as needed.
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                          ),
                        ),
                        const MealCategory(),
                      ],
                    );
                  },
                ).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
