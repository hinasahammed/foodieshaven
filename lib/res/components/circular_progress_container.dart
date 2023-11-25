import 'package:flutter/material.dart';
import 'package:foodies_haven/viewModel/get_started_controller.dart';
import 'package:get/get.dart';

class CircularProgressContainer extends StatefulWidget {
  const CircularProgressContainer({super.key});

  @override
  State<CircularProgressContainer> createState() =>
      _CircularProgressContainerState();
}

class _CircularProgressContainerState extends State<CircularProgressContainer> {
  final controller = Get.put(GetStartedController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        controller.updateCount();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: Get.width * 3,
            height:
                Get.height * .07, // Adjust the size of your circular container
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  theme.colorScheme.onBackground, // Change the color as needed
            ),
            child: Center(
              child: Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: SizedBox(
              width: Get.width * .16,
              height: Get.height * .07,
              child: CircularProgressIndicator(
                value: 0.8,
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                strokeWidth: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
