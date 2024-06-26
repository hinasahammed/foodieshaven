import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/edit_profile.dart';
import 'package:foodies_haven/utils/utils.dart';
import 'package:foodies_haven/view/favourite.dart';
import 'package:foodies_haven/view/login.dart';
import 'package:foodies_haven/view/my_cart.dart';
import 'package:foodies_haven/view/my_order.dart';
import 'package:foodies_haven/viewModel/theme_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final auth = FirebaseAuth.instance;
  final _getStorage = GetStorage();

  void logout() async {
    try {
      await auth.signOut().then(
            (value) => Get.offAll(
              const LoginView(),
            ),
          );
    } catch (e) {
      Utils().showSnackBar('Error', e.toString());
    }
  }

  void showEdit(String userName) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          EditProfile(userName: userName, uid: auth.currentUser!.uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userData')
            .where("uid", isEqualTo: auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.black.withOpacity(0.2),
              highlightColor: Colors.white54,
              enabled: true,
              child: Container(
                width: Get.width * .3,
                height: Get.height * .14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black54,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              snapshot.data == null) {
            return Center(
              child: Text(
                'No data found!',
                style: theme.textTheme.titleLarge!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.docs.map((userData) {
                  return Container(
                    width: Get.width,
                    height: Get.height * .79,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            width: Get.width * .3,
                            height: Get.height * .14,
                            imageUrl: userData['imageUrl'] ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.white54,
                              enabled: true,
                              child: Container(
                                width: Get.width * .3,
                                height: Get.height * .14,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Text(
                          userData['userName'] ?? '',
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData['email'] ?? '',
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(.6),
                          ),
                        ),
                        const Spacer(),
                        Card(
                          child: ListTile(
                            onTap: () {
                              Get.to(
                                () => const MyCartView(),
                              );
                            },
                            leading: const Icon(Icons.shopping_cart),
                            title: const Text('My cart'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            onTap: () {
                              Get.to(() => const FavouriteView());
                            },
                            leading: const Icon(Icons.favorite),
                            title: const Text('Favourites'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            onTap: () {
                              Get.to(() => const MyOrderView());
                            },
                            leading: const Icon(Icons.shopping_bag),
                            title: const Text('My order'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            onTap: () {
                              showEdit(userData['userName'] ?? '');
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text('Edit'),
                          ),
                        ),
                        Card(
                          child: SwitchListTile(
                            onChanged: (value) {
                              ThemeController().changeThemeMode();
                            },
                            value: _getStorage.read('isDarkMode') ?? false,
                            title: const Text('Dark mode'),
                          ),
                        ),
                        const Spacer(),
                        Card(
                          child: ListTile(
                            onTap: logout,
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
