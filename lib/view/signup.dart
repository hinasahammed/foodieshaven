import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/custom_button.dart';
import 'package:foodies_haven/res/components/custom_image_picker.dart';
import 'package:foodies_haven/res/components/custom_textfield.dart';
import 'package:foodies_haven/utils/utils.dart';
import 'package:foodies_haven/view/login.dart';
import 'package:foodies_haven/viewModel/signup_controller.dart';
import 'package:foodies_haven/viewModel/upload_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? selectedImage;

  final uploadController = Get.put(
    UploadController(),
  );

  final signupController = Get.put(
    SignupController(),
  );

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              const CustomImagePicker(),
              const Gap(40),
              CustomTextfield(
                controller: _usernameController,
                text: 'User name',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username is required';
                  }

                  if (value.length < 3) {
                    return 'Username must be at least 3 characters long';
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
                    return 'Email required';
                  }
                  final emailRegExp =
                      RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Enter a valid email address';
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
                    return 'Password is required';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'Must contain at least one number';
                  }
                  return null;
                },
              ),
              const Gap(20),
              CustomButton(
                  loading: signupController.loading.value,
                  text: 'Sign up',
                  onPressed: () async {
                    if (uploadController.selectedImage.value.path.isNotEmpty) {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        await signupController.createAccount(
                            _emailController.text,
                            _usernameController.text,
                            _passwordController.text,
                            DateFormat.yMMMd().format(DateTime.now()));
                      }
                    } else {
                      Utils().showSnackBar(
                          'Image Error', 'You have to select image');
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
