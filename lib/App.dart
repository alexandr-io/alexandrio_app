import 'package:flutter/material.dart';

import 'Pages/Home.dart';
import 'Theme/ThemeManager.dart';

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();

  // ignore: invalid_use_of_protected_member
  static void rebuild(BuildContext context) => of(context).setState(() {});
  static AppState of(BuildContext context) => context.findAncestorStateOfType<AppState>();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) => ThemeManager(
        child: Builder(
          builder: (BuildContext context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeManager.of(context).mode,
            theme: ThemeManager.of(context).light(),
            darkTheme: ThemeManager.of(context).dark(),
            home: HomePage(),
          ),
        ),
      );
}
