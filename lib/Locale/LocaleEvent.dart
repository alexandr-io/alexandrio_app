import 'package:equatable/equatable.dart';

class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class LocaleInitialized extends LocaleEvent {}

class LocaleChanged extends LocaleEvent {
  final String locale;

  const LocaleChanged(this.locale) : super();

  @override
  List<Object> get props => [locale, ...super.props];
}
