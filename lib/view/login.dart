import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/custom_button.dart';
import 'package:foodies_haven/res/components/custom_textfield.dart';
import 'package:foodies_haven/view/signup.dart';
import 'package:foodies_haven/viewModel/signin_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final loginController = Get.put(SigninController());

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  bool __obscureText = true;

  void _togglePasswordVisibility(bool newValue) {
    setState(() {
      __obscureText = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animation/login_anim.json',
                  fit: BoxFit.cover,
                  width: Get.width * .8,
                ),
                Text(
                  "Let's you in",
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(20),
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
                  isObsecure: __obscureText,
                  toggleVisibility: _togglePasswordVisibility,
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
                  loading: loginController.loading.value,
                  text: 'Sign in',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      await loginController.signin(
                        _emailController.text,
                        _passwordController.text,
                      );
                    }
                    return;
                  },
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const SignupView());
                      },
                      child: Text(
                        "Sign up",
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
      ),
    );
  }
}
