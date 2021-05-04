import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'ThemeEvent.dart';
import 'ThemeState.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Box themeBox;

  ThemeBloc(this.themeBox) : super(ThemeLoading()) {
    add(ThemeInitialized());
  }

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeInitialized) {
      var themeMode = themeBox.get('themeMode');
      var themeColor = themeBox.get('themeColor');
      yield ThemeLoaded(
        mode: themeMode != null ? ThemeMode.values[themeMode] : ThemeMode.system,
        color: themeColor ?? 'red',
      );
    } else if (event is ThemeModeChanged) {
      var previousState = state as ThemeLoaded;
      await themeBox.put('themeMode', event.mode.index);
      yield previousState.copyWith(mode: event.mode);
    }
  }
}
