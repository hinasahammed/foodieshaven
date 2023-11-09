import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MealCategory extends StatefulWidget {
  const MealCategory({super.key});

  @override
  State<MealCategory> createState() => _MealCategoryState();
}

class _MealCategoryState extends State<MealCategory> {
  List text = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Supper',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meal Category',
              style: theme.textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              'See all',
              style: theme.textTheme.labelMedium!.copyWith(
                color: Colors.white54,
              ),
            ),
          ],
        ),
        const Gap(10),
        SizedBox(
          height: Get.height * .1,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Gap(15),
            scrollDirection: Axis.horizontal,
            itemCount: text.length,
            itemBuilder: (context, index) => Column(
              children: [
                Container(
                  height: Get.height * .06,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(.6),
                        theme.colorScheme.primaryContainer.withOpacity(.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/burger_cl.png',
                        fit: BoxFit.contain,
                      ),
                      Text(
                        text[index],
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('food').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No data found!',
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.white,
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
                  childAspectRatio: .7,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final foodData = snapshot.data!.docs[index];
                  return Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Stack(
                      children: [
                        Container(
                          width: Get.width * .4,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                foodData['title'],
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                foodData['title'],
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                foodData['title'],
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 150,
                          left: 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              width: Get.width * .3,
                              height: Get.height * .14,
                              child: Image.network(
                                foodData['url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
