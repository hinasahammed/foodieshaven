import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/view/food_details.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeTopCard extends StatelessWidget {
  final String image;
  final String title;
  final String time;
  const HomeTopCard({
    super.key,
    required this.image,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(
              () => FoodDetails(title: title),
            );
          },
          child: Container(
            height: Get.height * .18,
            width: Get.width * .9,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(10),
                        Text(
                          'Today Specials',
                          style: theme.textTheme.labelSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          width: Get.width * .45,
                          child: Text(
                            title[0].toUpperCase() + title.substring(1),
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                              time,
                              style: theme.textTheme.labelSmall!.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Gap(15),
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            width: 90,
                            height: 90,
                            imageUrl: image,
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
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
