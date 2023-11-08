import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final bool isObsecure;
  final String text;
  final TextInputAction textInputAction;
  final String? Function(String?) validator;
  const CustomTextfield({
    super.key,
    required this.controller,
    this.isObsecure = false,
    required this.text,
    required this.textInputAction,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      style: TextStyle(color: theme.colorScheme.primary),
      obscureText: isObsecure,
      textInputAction: textInputAction,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(text),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        filled: true,
        fillColor: theme.colorScheme.primary.withOpacity(.03),
        suffixIcon: isObsecure
            ? Icon(isObsecure ? Icons.visibility_off : Icons.visibility)
            : const Gap(1),
      ),
      validator: validator,
    );
  }
}
