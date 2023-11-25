import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/shimmer_list.dart';
import 'package:foodies_haven/viewModel/ordering_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class MyOrderView extends StatefulWidget {
  const MyOrderView({super.key});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  final auth = FirebaseAuth.instance;
  final orderController = Get.put(OrderingController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userData')
            .doc(auth.currentUser!.uid)
            .collection('userOrder')
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
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: theme.colorScheme.secondary.withOpacity(.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order will be delivered in ${foodData['timeTake']}',
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const Gap(20),
                        Text(
                          foodData['Name'][0].toString().toUpperCase() +
                              foodData['Name'].toString().substring(1),
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                        const Gap(10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            width: double.infinity,
                            height: Get.height * .3,
                            imageUrl: foodData['url'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.white54,
                              enabled: true,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name:',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * .36,
                              child: Text(
                                foodData['Name'][0].toString().toUpperCase() +
                                    foodData['Name'].toString().substring(1),
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: theme.colorScheme.onBackground,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Count:',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                            Text(
                              foodData['Count'].toString(),
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          ],
                        ),
                        Divider(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'date:',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                            Text(
                              DateFormat.yMMMd()
                                  .format(DateTime.parse(foodData['date'])),
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          ],
                        ),
                        Divider(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Table:',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                            Text(
                              foodData['tableNo'],
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          ],
                        ),
                        Divider(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${foodData['Total']}',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          ],
                        ),
                        const Gap(10),
                      ],
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
