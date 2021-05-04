import 'package:alexandrio_app/Credentials/CredentialsBloc.dart';
import 'package:alexandrio_app/Credentials/CredentialsEvent.dart';
import 'package:alexandrio_app/Locale/LocaleBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/Adapters/ColorAdapter.dart';
import '/App.dart';
import '/Theme/ThemeBloc.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ColorAdapter());
  var themeBox = await Hive.openBox('Theme');
  var settingsBox = await Hive.openBox('Settings');
  var credentialsBox = await Hive.openBox('Credentials');

  runApp(
    BlocProvider(
      create: (BuildContext context) => CredentialsBloc(),
      child: BlocProvider(
        create: (BuildContext context) => LocaleBloc(settingsBox),
        child: BlocProvider(
          create: (BuildContext context) => ThemeBloc(themeBox),
          child: App(),
        ),
      ),
    ),
  );
}
