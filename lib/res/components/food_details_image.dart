import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class FoodDetailsImage extends StatelessWidget {
  final String imageUrl;
  const FoodDetailsImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: CachedNetworkImage(
        width: Get.width,
        height: Get.height * .33,
        imageUrl: imageUrl,
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.black.withOpacity(0.2),
          highlightColor: Colors.white54,
          enabled: true,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
