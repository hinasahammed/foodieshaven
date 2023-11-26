import 'package:flutter/material.dart';

class CartBottomCard extends StatelessWidget {
  final String title;
  final String value;
  const CartBottomCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        )
      ],
    );
  }
}
