import 'package:flutter/material.dart';
import 'package:foodies_haven/main.dart';

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
