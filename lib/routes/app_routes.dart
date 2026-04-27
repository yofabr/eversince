import 'package:flutter/material.dart';

import '../presentation/home_screen/home_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String homeScreen = '/home-screen';
  static const String settingsScreen = '/settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    homeScreen: (context) => const HomeScreen(),
    settingsScreen: (context) => const SettingsScreen(),
  };
}
