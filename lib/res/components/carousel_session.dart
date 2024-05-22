import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/home_top_card.dart';
import 'package:foodies_haven/res/components/home_top_shimmer.dart';

class CarouselSession extends StatelessWidget {
  const CarouselSession({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('food')
          .where('special', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const HomeTopShimmer();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return !snapshot.hasData || snapshot.data!.docs.isEmpty
            ? Center(
                child: Text(
                  'No special food',
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              )
            : CarouselSlider(
                items: snapshot.data!.docs.map((fooData) {
                  return HomeTopCard(
                    image: fooData['url'],
                    title: fooData['title'],
                    time: fooData['time'],
                  );
                }).toList(),
                options: CarouselOptions(
                  aspectRatio:
                      16 / 9, // You can adjust this aspect ratio as needed.
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                ),
              );
      },
    );
  }
}
