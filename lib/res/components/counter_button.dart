import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  final double width;
  final IconData icon;
  final void Function() onTap;
  const CounterButton({
    super.key,
    required this.width,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.primary,
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
