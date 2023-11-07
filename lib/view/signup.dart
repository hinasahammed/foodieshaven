import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/custom_button.dart';
import 'package:foodies_haven/res/components/custom_image_picker.dart';
import 'package:foodies_haven/res/components/custom_textfield.dart';
import 'package:foodies_haven/view/login.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? selectedImage;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void save() {
    print('validated');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Create New Account",
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(80),
              CustomImagePicker(
                onImageSelected: (image) {
                  setState(() {
                    selectedImage = image;
                  });
                },
              ),
              const Gap(40),
              CustomTextfield(
                controller: _emailController,
                text: 'User name',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter user name';
                  }
                  return null;
                },
              ),
              const Gap(15),
              CustomTextfield(
                controller: _emailController,
                text: 'Email',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Email';
                  }
                  return null;
                },
              ),
              const Gap(15),
              CustomTextfield(
                controller: _passwordController,
                text: 'Password',
                textInputAction: TextInputAction.done,
                isObsecure: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Password';
                  }
                  return null;
                },
              ),
              const Gap(20),
              CustomButton(
                  text: 'Sign up',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      save();
                    }
                  }),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const LoginView());
                    },
                    child: Text(
                      "Sign in",
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
