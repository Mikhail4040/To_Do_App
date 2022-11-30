
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage box=GetStorage();
  final key="isDarkMode";

  bool loadThemeFromBox(){
   return box.read<bool>(key) ?? false;
  }

  void saveThemeToBox(bool isDarkMode){
       box.write(key, isDarkMode);
  }

  ThemeMode get theme=>loadThemeFromBox() ? ThemeMode.dark:ThemeMode.light;

  void switchTheme(){
   Get.changeThemeMode(loadThemeFromBox()?ThemeMode.light :ThemeMode.dark);
   saveThemeToBox(!loadThemeFromBox());
  }

}
