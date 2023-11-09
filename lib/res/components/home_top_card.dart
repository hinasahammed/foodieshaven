import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomeTopCard extends StatelessWidget {
  final String image;
  const HomeTopCard({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          height: Get.height * .18,
          width: Get.width * .9,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(.15),
                Colors.black12.withOpacity(.1),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(10),
                      Text(
                        'New recipes',
                        style: theme.textTheme.labelSmall!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const Gap(10),
                      Text(
                        'Burger',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.timelapse,
                              color: Colors.black45,
                              size: 15,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            '30 min',
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const Gap(10),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.graphic_eq,
                              color: Colors.black45,
                              size: 15,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            'Easy lvl',
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const Gap(15),
                  Column(
                    children: [
                      Image.asset(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
