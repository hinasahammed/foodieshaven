import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final bool isObsecure;
  final String text;
  final TextInputAction textInputAction;
  final String? Function(String?) validator;
  final Function(bool)? toggleVisibility;
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.text,
    this.isObsecure = false,
    required this.textInputAction,
    required this.validator,
    this.toggleVisibility,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      style: TextStyle(color: theme.colorScheme.primary),
      obscureText: widget.isObsecure,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(widget.text),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        filled: true,
        fillColor: theme.colorScheme.primary.withOpacity(.03),
        suffixIcon: widget.text == "Password"
            ? IconButton(
                onPressed: () {
                  widget.toggleVisibility!(!widget.isObsecure);
                },
                icon: Icon(widget.isObsecure
                    ? Icons.visibility_off
                    : Icons.visibility),
              )
            : const Gap(1),
      ),
      validator: widget.validator,
    );
  }
}
