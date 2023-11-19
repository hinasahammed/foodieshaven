import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/carousel_session.dart';
import 'package:foodies_haven/res/components/home_top_shimmer.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeTopSession extends StatefulWidget {
  const HomeTopSession({super.key});

  @override
  State<HomeTopSession> createState() => _HomeTopSessionState();
}

class _HomeTopSessionState extends State<HomeTopSession> {
  final auth = FirebaseAuth.instance;

  final List<String> imageList = [
    "assets/images/burger_cl2.png",
    "assets/images/burger_mid.png",
    "assets/images/burger_op.png",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userData')
          .where("uid", isEqualTo: auth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const HomeTopShimmer();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Center(
              child: Text('No Data Found!'),
            ),
          );
        } else {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
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
                                  style: theme.textTheme.bodyLarge!.copyWith(
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
                                  style: theme.textTheme.bodyLarge!.copyWith(
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
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.black.withOpacity(0.2),
      highlightColor: Colors.white54,
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
                    const CarouselSession()
                  ],
                );
              },
            ).toList(),
          );
        }
      },
    );
  }
}
