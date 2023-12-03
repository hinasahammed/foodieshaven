import 'package:flutter/material.dart';
import 'package:foodies_haven/view/splash.dart';
import 'package:foodies_haven/viewModel/theme_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// final darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: const ColorScheme.dark(
//     primary: Color(0xff008000),
//   ),
//   useMaterial3: true,
// );
// final lightTheme = ThemeData(
//   brightness: Brightness.light,
//   colorScheme: const ColorScheme.light(
//     primary: Color(0xff008000),
//   ),
//   useMaterial3: true,
//   textTheme: GoogleFonts.robotoMonoTextTheme(),
// );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Foodie's Haven",
      theme: MyThemes.appThemeData,
      darkTheme: MyThemes.darkThemeData,
      themeMode: ThemeController().getThemeMode(),
      home: const SplashView(),
    );
  }
}
