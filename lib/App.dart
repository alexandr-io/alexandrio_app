import 'package:demo/Pages/Landing.dart';
import 'package:flutter/material.dart';

import 'ThemeBuilder.dart';
import 'backend/APIConnector.dart';

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();

  static void setState(BuildContext context, Function func) => context.findAncestorStateOfType<AppState>().setState(func);
}

class AppState extends State<App> {
  var api = APIConnector();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeBuilder.of(context).light(),
      darkTheme: ThemeBuilder.of(context).dark(),
      themeMode: ThemeBuilder.of(context).themeMode,
      home: Builder(
        builder: (BuildContext context) => Material(
          child: Landing(),
        ),
      ),
    );
  }
}
