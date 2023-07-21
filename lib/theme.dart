import 'package:flutter/material.dart';
import 'package:flutter_ia/colors.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode =
      ThemeMode.system.obs; // Use Rx<ThemeMode> for reactivity

  void toggleTheme() {
    if (themeMode.value == ThemeMode.system) {
      // If the current theme is system theme, switch to the opposite theme
      if (Get.isDarkMode) {
        themeMode.value = ThemeMode.light;
      } else {
        themeMode.value = ThemeMode.dark;
      }
    } else {
      // If the current theme is manually set, switch to the system theme
      themeMode.value = ThemeMode.system;
    }
    Get.changeThemeMode(themeMode.value);
  }
}

class AppTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: const ColorScheme.dark(),
    primaryColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 20, 20, 20),
    ),
    dialogBackgroundColor: Colors.grey.shade900,
    dividerColor: Color.fromARGB(255, 48, 48, 48),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 17, 162, 104),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    dialogBackgroundColor: Colors.white,
    dividerColor: Colors.grey[200],
  );
}
