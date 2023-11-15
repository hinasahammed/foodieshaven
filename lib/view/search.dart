import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/search_bottom_session.dart';
import 'package:gap/gap.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Column(
            children: [
              Container(
                height: 55,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: theme.textTheme.labelLarge!.copyWith(
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        _searchController.text = value;
                      },
                    );
                  },
                ),
              ),
              const Gap(20),
              Expanded(
                child: SearchBottomSession(controller: _searchController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
