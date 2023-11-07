import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:foodies_haven/view/login.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    nextSession();
  }

  void nextSession() {
    Timer(const Duration(seconds: 3), () {
      Get.to(
        () => const LoginView(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/burger_cl.png',
              width: 300,
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .then(delay: 200.ms) // baseline=800ms
                .slide(),
            Text(
              "Foodie's Haven",
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fade(delay: 100.ms).scale(),
          ],
        ),
      ),
    );
  }
}
