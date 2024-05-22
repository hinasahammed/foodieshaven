import 'package:flutter/material.dart';
import 'package:foodies_haven/view/signup.dart';
import 'package:foodies_haven/viewModel/get_started_controller.dart';
import 'package:get/get.dart';

class CircularProgressContainer extends StatefulWidget {
  final PageController pageController;
  final bool isLastStep;
  const CircularProgressContainer(
      {super.key, required this.pageController, required this.isLastStep});

  @override
  State<CircularProgressContainer> createState() =>
      _CircularProgressContainerState();
}

class _CircularProgressContainerState extends State<CircularProgressContainer> {
  final controller = Get.put(GetStartedController());

  double calculateProgress() {
    final double page = (widget.pageController.page ?? 0).clamp(0, 3.0);
    return page / 3.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        if (widget.isLastStep) {
          Get.offAll(() => const SignupView());
          controller.isStarted.value = true;
        } else {
          widget.pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        }
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
                  theme.colorScheme.onSurface, // Change the color as needed
            ),
            child: Center(
              child: Icon(
                widget.isLastStep ? Icons.check : Icons.arrow_forward_ios,
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
                value: calculateProgress(),
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
