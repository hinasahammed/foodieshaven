import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStartedCard extends StatelessWidget {
  final String text;
  const GetStartedCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(.1),
            blurRadius: 4,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(.2),
            blurRadius: 4,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Text(
        text,
        style: theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
