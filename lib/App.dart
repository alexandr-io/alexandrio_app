import 'package:flutter/material.dart';
import 'package:flutter_ui_tools/ThemeableMaterialApp.dart';

import 'Pages/Login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ThemeableMaterialApp(
        appBuilder: (BuildContext context, ThemeData darkTheme, ThemeData lightTheme, ThemeMode themeMode) => MaterialApp(
          title: 'Alexandr.io',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: LoginPage(),
        ),
      );
}
