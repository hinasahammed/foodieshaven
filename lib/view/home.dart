import 'package:flutter/material.dart';
import 'package:foodies_haven/main.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              Text(
                "Foodie's Haven",
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
