import 'package:flutter/material.dart';
import 'package:flutter_ui_tools/ThemeableMaterialApp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Pages/Login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ThemeableMaterialApp(
        appBuilder: (BuildContext context, ThemeData darkTheme, ThemeData lightTheme, ThemeMode themeMode) => MaterialApp(
          title: 'Alexandrio',
          debugShowCheckedModeBanner: false,
          theme: lightTheme.copyWith(
              // platform: TargetPlatform.android,
              ),
          darkTheme: darkTheme.copyWith(
              // platform: TargetPlatform.android,
              ),
          themeMode: themeMode,
          home: LoginPage(),
          locale: Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
}
