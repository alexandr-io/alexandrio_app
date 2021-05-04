import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData buildTheme(Brightness brightness) {
    var baseColorScheme = brightness == Brightness.light ? ColorScheme.light() : ColorScheme.dark();
    var colorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.deepOrange,
      accentColor: Colors.deepOrangeAccent,
      brightness: brightness,
      backgroundColor: brightness == Brightness.dark ? Colors.grey[900] : baseColorScheme.background,
    ).copyWith(
      surface: brightness == Brightness.dark ? Colors.grey[850] : baseColorScheme.surface,
    );
    var themeData = ThemeData.from(colorScheme: colorScheme);
    return themeData.copyWith(
      toggleableActiveColor: colorScheme.primary,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: themeData.hintColor,
        ),
        shadowColor: Colors.black45,
        color: colorScheme.surface,
        textTheme: TextTheme(
          headline6: TextStyle().copyWith(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: themeData.hintColor,
          ),
        ),
      ),
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 0.0, color: Colors.transparent),
        ),
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withAlpha(192),
      ),
      platform: TargetPlatform.fuchsia,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }
}

// darkTheme: ThemeData.dark().copyWith(
//   accentColor: Colors.deepPurpleAccent,
//   primaryColor: Colors.deepPurple,
// ),
// darkTheme: ThemeData.from(
//   colorScheme: ColorScheme.dark().copyWith(
//     primary: Colors.pink[200]!,
//     primaryVariant: Colors.pink[200]!,
//     secondary: Colors.pink[200]!,
//     secondaryVariant: Colors.pink[200]!,
//   ),
// ).copyWith(
//   platform: TargetPlatform.fuchsia,
//   toggleableActiveColor: Colors.pink[200]!,
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: ColorScheme.dark().surface,
//     foregroundColor: Colors.pink[200]!,
//   ),
// ),
// theme: ThemeData.from(
//   colorScheme: ColorScheme.light().copyWith(
//     primary: Colors.pink[300]!,
//     primaryVariant: Colors.pink[300]!,
//     secondary: Colors.pink[300]!,
//     secondaryVariant: Colors.pink[300]!,
//   ),
// ).copyWith(
//   platform: TargetPlatform.fuchsia,
//   toggleableActiveColor: Colors.pink[300]!,
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: ColorScheme.light().surface,
//     foregroundColor: Colors.pink[300]!,
//   ),
// ),
