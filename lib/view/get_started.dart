import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/get_started_card.dart';
import 'package:get/get.dart';

class GetStarted extends StatefulWidget {
  final PageController controller;
  final String image;
  final String text;
  const GetStarted({
    super.key,
    required this.controller,
    required this.image,
    required this.text,
  });

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              widget.image,
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
                        widget.controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.controller.jumpToPage(4);
                    },
                    child: Text(
                      'Skip',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(
                flex: 3,
              ),
              GetStartedCard(text: widget.text),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
