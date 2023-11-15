import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/home_top_session.dart';
import 'package:foodies_haven/res/components/meal_category.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: Get.height * .35,
            child: const HomeTopSession(),
          ),
          const Expanded(
            child: MealCategory(),
          )
        ],
      )),
    );
  }
}
