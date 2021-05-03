import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_tools/ThemeableMaterialApp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Locale/LocaleBloc.dart';
import 'Locale/LocaleState.dart';
import 'Pages/Login.dart';
import 'Theme/ThemeBloc.dart';
import 'Theme/ThemeState.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) => BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            if (themeState is ThemeLoaded && localeState is LocaleLoaded) {
              return ThemeableMaterialApp(
                appBuilder: (BuildContext context, ThemeData darkTheme, ThemeData lightTheme, ThemeMode themeMode) => MaterialApp(
                  title: 'Alexandrio',
                  debugShowCheckedModeBanner: false,
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: themeState.mode,
                  home: LoginPage(),
                  locale: localeState.locale != null ? Locale(localeState.locale) : null,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      );
}
