import 'package:flutter/material.dart';

ThemeData buildThemeData(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: brightness,
  );

  final backgroundColor = colorScheme.surfaceContainerLowest;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(centerTitle: true),
    tabBarTheme: const TabBarTheme(indicatorSize: TabBarIndicatorSize.tab),
    chipTheme: ChipThemeData(backgroundColor: backgroundColor),
    searchBarTheme: const SearchBarThemeData(
      elevation: WidgetStatePropertyAll(0),
    ),
  );
}
