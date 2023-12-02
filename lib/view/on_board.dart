import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/circular_progress_container.dart';
import 'package:foodies_haven/view/get_started.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardView extends StatefulWidget {
  const OnBoardView({super.key});

  @override
  State<OnBoardView> createState() => _OnBoardViewState();
}

class _OnBoardViewState extends State<OnBoardView> {
  PageController pageController = PageController();
  bool onLastPage = false;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 4);
              });
            },
            children: [
              GetStarted(
                controller: pageController,
                image: 'assets/images/bg1.png',
                text: 'Welcome to\nFoodie\'s Haven',
              ),
              GetStarted(
                controller: pageController,
                image: 'assets/images/bg2.png',
                text: 'Sign up with your email address',
              ),
              GetStarted(
                controller: pageController,
                image: 'assets/images/bg3.png',
                text: 'Choose your favourite food of your choice by our app',
              ),
              GetStarted(
                controller: pageController,
                image: 'assets/images/bg4.png',
                text: 'Use the search bar to find specific dishes',
              ),
              GetStarted(
                controller: pageController,
                image: 'assets/images/bg5.png',
                text:
                    'Choose your preferred table from a real-time seating chart',
              ),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.95),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircularProgressContainer(
                  pageController: pageController,
                  isLastStep: onLastPage,
                ),
                const Gap(10),
                SmoothPageIndicator(controller: pageController, count: 5),
                const Gap(20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
