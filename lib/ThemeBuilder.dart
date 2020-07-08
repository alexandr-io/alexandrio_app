import 'package:flutter/material.dart';

class ThemeBuilderState extends State<ThemeBuilder> {
  MaterialColor accentColor = Colors.orange;
  ThemeMode themeMode = ThemeMode.system;
  PageTransitionsTheme pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.windows: ZoomPageTransitionsBuilder(),
    },
  );

  Color accentOnBackground(ThemeData data) => (data.brightness == Brightness.light) ? accentColor[300] : accentColor[200];
  Color accentOnBackgroundGlobal(BuildContext context) => accentOnBackground(Theme.of(context));

  ButtonThemeData buttonThemeData(ThemeData data, ButtonThemeData buttonData) => buttonData.copyWith(
        buttonColor: accentOnBackground(data),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        textTheme: ButtonTextTheme.primary,
        colorScheme: buttonData.colorScheme.copyWith(
          primary: accentOnBackground(data),
          brightness: Brightness.light,
        ),
      );

  ThemeData applyGlobal(ThemeData data) => data.copyWith(
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: pageTransitionsTheme,
        buttonTheme: buttonThemeData(data, data.buttonTheme),
        accentColor: accentOnBackground(data),
        primaryColor: accentOnBackground(data),
        textSelectionColor: accentOnBackground(data),
        textSelectionHandleColor: accentOnBackground(data),
        cursorColor: accentOnBackground(data),
      );

  ThemeData dark() {
    return applyGlobal(
      ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.grey[850],
          iconTheme: IconThemeData(
            color: Colors.grey[500],
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[500],
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: ColorScheme.dark().copyWith(
          primary: accentOnBackground(ThemeData.dark()),
          secondary: Colors.grey[850],
          onSecondary: accentOnBackground(ThemeData.dark()),
        ),
        canvasColor: Colors.grey[900],
      ),
    );
  }

  ThemeData light() {
    return applyGlobal(
      ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.grey[50],
          iconTheme: IconThemeData(
            color: Colors.grey[600],
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[600],
        ),
        primaryColorBrightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.light().copyWith(
          primary: accentOnBackground(ThemeData.light()),
          secondary: Colors.grey[50],
          onSecondary: accentOnBackground(ThemeData.light()),
        ),
        canvasColor: Colors.grey[50],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class ThemeBuilder extends StatefulWidget {
  final Widget child;

  const ThemeBuilder({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  ThemeBuilderState createState() => ThemeBuilderState();

  static ThemeBuilderState of(BuildContext context) => context.findAncestorStateOfType<ThemeBuilderState>();
}
