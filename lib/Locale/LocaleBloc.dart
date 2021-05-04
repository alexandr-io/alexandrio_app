import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'LocaleEvent.dart';
import 'LocaleState.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final Box settingsBox;

  LocaleBloc(this.settingsBox) : super(LocaleLoading()) {
    add(LocaleInitialized());
  }

  @override
  Stream<LocaleState> mapEventToState(LocaleEvent event) async* {
    if (event is LocaleInitialized) {
      var locale = await settingsBox.get('locale');
      yield LocaleLoaded(locale);
    } else if (event is LocaleChanged) {
      await settingsBox.put('locale', event.locale);
      yield LocaleLoaded(event.locale);
    }
  }
}
