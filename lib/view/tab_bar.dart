import 'package:flutter/material.dart';
import 'package:foodies_haven/view/home.dart';
import 'package:foodies_haven/view/search.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class TabBarControlView extends StatefulWidget {
  const TabBarControlView({super.key});

  @override
  State<TabBarControlView> createState() => _TabBarControlViewState();
}

class _TabBarControlViewState extends State<TabBarControlView> {
  var currentIndex = 0;

  final _pages = [
    const HomeView(),
    const SearchView(),
    const Center(
      child: Text('Account'),
    )
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GNav(
          color: theme.colorScheme.primary,
          activeColor: theme.colorScheme.onPrimary,
          tabBackgroundColor: theme.colorScheme.primary,
          gap: 8,
          padding: const EdgeInsets.all(12),
          onTabChange: (newIndex) {
            setState(() {
              currentIndex = newIndex;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home_filled,
              text: 'Home',
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
            ),
            GButton(
              icon: Icons.person,
              text: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
