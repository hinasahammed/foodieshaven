import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController {
  static final _getStorage = GetStorage();
  final _storageKey = "isDarkMode";

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isSavedDarkMode() {
    return _getStorage.read(_storageKey) ?? false;
  }

  void saveThemeMode(bool isDarkmode) {
    _getStorage.write(_storageKey, isDarkmode);
  }

  void changeThemeMode() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    saveThemeMode(!isSavedDarkMode());
  }
}

class MyThemes {
  static final ThemeData appThemeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff008000),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.robotoMonoTextTheme(),
  );

  static final ThemeData darkThemeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff008000),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.robotoMonoTextTheme(),
  );
}
