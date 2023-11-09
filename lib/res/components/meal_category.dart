import 'package:flutter/material.dart';

class MealCategory extends StatelessWidget {
  const MealCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'New recipes',
              style: theme.textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              'See all',
              style: theme.textTheme.labelMedium!.copyWith(
                color: Colors.white54,
              ),
            ),
          ],
        )
      ],
    );
  }
}
