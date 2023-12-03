import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final bool loading;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      child: loading
          ? CircularProgressIndicator(
              color: theme.colorScheme.primary,
            )
          : Text(text),
    );
  }
}
