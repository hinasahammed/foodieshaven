import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutRowSession extends StatelessWidget {
  final String name;
  final String title;
  const CheckoutRowSession(
      {super.key, required this.name, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(
          width: Get.width * .3,
          child: Text(
            name,
            style: theme.textTheme.labelLarge!.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        )
      ],
    );
  }
}
