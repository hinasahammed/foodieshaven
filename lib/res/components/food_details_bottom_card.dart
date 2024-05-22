import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodies_haven/view/checkout_view.dart';
import 'package:foodies_haven/viewModel/cart_controller.dart';
import 'package:foodies_haven/viewModel/favourite_controller.dart';
import 'package:foodies_haven/viewModel/ordering_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class FoodDetailsBottomCard extends StatefulWidget {
  final String id;
  final String category;
  final String desc;
  final String price;
  final String rating;
  final String time;
  final String title;
  final String url;
  final bool special;
  const FoodDetailsBottomCard({
    super.key,
    required this.id,
    required this.category,
    required this.desc,
    required this.price,
    required this.rating,
    required this.time,
    required this.title,
    required this.url,
    required this.special,
  });

  @override
  State<FoodDetailsBottomCard> createState() => _FoodDetailsBottomCardState();
}

class _FoodDetailsBottomCardState extends State<FoodDetailsBottomCard> {
  final favouriteController = Get.put(FavouriteController());
  final orderController = Get.put(OrderingController());
  final cartController = Get.put(CartController());

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
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
            color: theme.colorScheme.secondaryContainer.withOpacity(.25),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(.2),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                    ),
                    color: theme.colorScheme.onSurface,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('userData')
                        .doc(auth.currentUser!.uid)
                        .collection('isFavourite')
                        .where('id', isEqualTo: widget.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const Text('Error');
                      }
                      return IconButton(
                        onPressed: () {
                          snapshot.data!.docs.isNotEmpty
                              ? favouriteController.removeFavourite(
                                  id: widget.id)
                              : favouriteController.addFavourite(
                                  id: widget.id,
                                  category: widget.category,
                                  desc: widget.desc,
                                  price: widget.price,
                                  rating: widget.rating,
                                  time: widget.time,
                                  title: widget.title,
                                  url: widget.url,
                                  special: widget.special,
                                  isFavourite: true,
                                );
                        },
                        icon: Icon(
                          snapshot.data!.docs.isNotEmpty
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          size: 25,
                        ),
                        color: snapshot.data!.docs.isNotEmpty
                            ? Colors.red
                            : theme.colorScheme.onSurface,
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width * .6,
                    child: Text(
                      widget.title[0].toUpperCase() + widget.title.substring(1),
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Text(
                    '₹${widget.price}'.toString(),
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              Text(
                widget.category.toString(),
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.time.toString(),
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: double.parse(widget.rating.toString()),
                    itemBuilder: (context, index) => const Icon(
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
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(10),
              Text(
                widget.desc[0].toUpperCase() + widget.desc.substring(1),
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
                    height: Get.height * .06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        if (orderController.count.value > 0) {
                          orderController.count.value--;
                        }
                      },
                      child: Text(
                        '-',
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(15),
                  Obx(
                    () => Text(
                      orderController.count.value.toString(),
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const Gap(15),
                  SizedBox(
                    width: Get.width * .15,
                    height: Get.height * .06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(1),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        orderController.count.value++;
                      },
                      child: Text(
                        '+',
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart_checkout),
                      onPressed: () {
                        cartController.addToCart(
                          id: const Uuid().v4(),
                          category: widget.category,
                          desc: widget.desc,
                          price: widget.price,
                          rating: widget.rating.toString(),
                          time: widget.time,
                          title: widget.title,
                          url: widget.url,
                          special: widget.special,
                        );
                      },
                      label: Text(
                        'Add to cart',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.document_scanner),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: theme.colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        Get.to(
                          () => CheckoutView(
                            imageUrl: widget.url,
                            name: widget.title,
                            count: orderController.count.value,
                            timeTake: widget.time,
                            amount: widget.price,
                            id: widget.id,
                          ),
                        );
                      },
                      label: Text(
                        'Checkout',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
