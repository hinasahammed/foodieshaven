import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/circular_progress_container.dart';
import 'package:foodies_haven/res/components/get_started_card.dart';
import 'package:foodies_haven/viewModel/get_started_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final controller = Get.put(GetStartedController());

  final List _content = [
    const GetStartedCard(text: 'Welcome to\nFoodie\'s Haven'),
    const GetStartedCard(text: 'Sign up with your email address'),
    const GetStartedCard(
        text: 'Choose your favourite food of your choice by our app'),
    const GetStartedCard(
        text: ' Choose your preferred table from a real-time seating chart.'),
    const GetStartedCard(text: ' Use the search bar to find specific dishes .'),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(
        () => Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/bg${controller.count.value + 1}.png',
              ),
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: Get.width * .1,
                      height: Get.height * .045,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (controller.count.value > 0) {
                            controller.decrementCount();
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Skip',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 16),
                _content[controller.count.value],
                const Gap(20),
                const CircularProgressContainer(),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width * .1,
                      height: Get.height * .02,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onBackground,
                        border: controller.count.value == 0
                            ? Border.all(
                                color: theme.colorScheme.primary, width: 3)
                            : const Border(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: Get.width * .1,
                      height: Get.height * .02,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onBackground,
                        border: controller.count.value == 1
                            ? Border.all(
                                color: theme.colorScheme.primary, width: 3)
                            : const Border(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: Get.width * .1,
                      height: Get.height * .02,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onBackground,
                        border: controller.count.value == 2
                            ? Border.all(
                                color: theme.colorScheme.primary, width: 3)
                            : const Border(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: Get.width * .1,
                      height: Get.height * .02,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onBackground,
                        border: controller.count.value == 3
                            ? Border.all(
                                color: theme.colorScheme.primary, width: 3)
                            : const Border(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: Get.width * .1,
                      height: Get.height * .02,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onBackground,
                        border: controller.count.value == 4
                            ? Border.all(
                                color: theme.colorScheme.primary, width: 3)
                            : const Border(),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
