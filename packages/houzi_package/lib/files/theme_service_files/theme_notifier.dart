import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/theme_service_files/theme_storage_manager.dart';

class ThemeNotifier with ChangeNotifier {

    ThemeMode? _themeMode;
    ThemeMode? getThemeMode() => _themeMode;

  static ThemeNotifier? _themeNotifier;

  factory ThemeNotifier() {
    _themeNotifier ??= ThemeNotifier._internal();
    return _themeNotifier!;
  }
  bool isDarkMode(){
    return isCurrentThemeDarkMode();
  }
  static bool isCurrentThemeDarkMode(){
    bool isDarkMode = false;
    ThemeMode current = currentThemeMode();
    if (current == ThemeMode.system) {
      var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode = brightness == Brightness.dark;
    } else if (current == ThemeMode.dark) {
      isDarkMode = true;
    } else if (current == ThemeMode.light) {
      isDarkMode = false;
    }

    return isDarkMode;
  }
  ThemeNotifier._internal(){
    _themeMode = currentThemeMode();
    notifyListeners();
  }
  static ThemeMode currentThemeMode(){
    ThemeMode currentTheme = ThemeMode.light;

    if (ThemeStorageManager.readData(THEME_MODE_INFO) == null) {
      // if user has not selected any theme mode, first read theme mode from the
      // hook if available, else assign LIGHT THEME MODE as default mode.
      DefaultAppThemeModeHook defaultAppThemeModeHook = HooksConfigurations.defaultAppThemeModeHook;
      if (defaultAppThemeModeHook != null) {
        String? themeModeHook = defaultAppThemeModeHook();
        if (themeModeHook == 'dark') {
          currentTheme = ThemeMode.dark;
        } else if (themeModeHook == 'system') {
          currentTheme = ThemeMode.system;
        } else {
          currentTheme = ThemeMode.light;
        }
      }
    } else {
      String themeMode = ThemeStorageManager.readData(THEME_MODE_INFO);
      if (themeMode == DARK_THEME_MODE) {
        currentTheme = ThemeMode.dark;
      } else if (themeMode == SYSTEM_THEME_MODE) {
        currentTheme = ThemeMode.system;
      } else {
        currentTheme = ThemeMode.light;
      }
    }

    return currentTheme;
  }


  void setDarkMode(){
    _themeMode = ThemeMode.dark;
    ThemeStorageManager.saveData(THEME_MODE_INFO, DARK_THEME_MODE);
    notifyListeners();
  }

  void setLightMode(){
    _themeMode = ThemeMode.light;
    ThemeStorageManager.saveData(THEME_MODE_INFO, LIGHT_THEME_MODE);
    notifyListeners();
  }

  void setSystemThemeMode(){
    _themeMode = ThemeMode.system;
    ThemeStorageManager.saveData(THEME_MODE_INFO, SYSTEM_THEME_MODE);
    notifyListeners();
  }
}