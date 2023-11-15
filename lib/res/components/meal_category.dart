import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/meal_category_bottom.dart';
import 'package:foodies_haven/view/all_meals.dart';
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

  String category = 'Breakfast';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Column(
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
              TextButton(
                onPressed: () {
                  Get.to(
                    ()=>const AllMeals(),
                  );
                },
                child: Text(
                  'See all',
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: Colors.white54,
                  ),
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
                  InkWell(
                    onTap: () {
                      setState(() {
                        category = text[index];
                      });
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: MealCategoryBottom(category: category),
          ),
        ],
      ),
    );
  }
}
