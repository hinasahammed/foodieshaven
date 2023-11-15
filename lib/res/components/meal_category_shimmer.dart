import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MealCategoryShimmer extends StatelessWidget {
  const MealCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black.withOpacity(0.2),
        highlightColor: Colors.white54,
        enabled: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: Get.width * .44,
              height: Get.height * .6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
              ),
            ),
            Container(
              width: Get.width * .44,
              height: Get.height * .6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
              ),
            ),
          ],
        ));
  }
}
