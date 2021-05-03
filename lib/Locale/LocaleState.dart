import 'package:equatable/equatable.dart';

class LocaleState extends Equatable {
  const LocaleState();

  @override
  List<Object> get props => [];
}

class LocaleLoading extends LocaleState {}

class LocaleLoaded extends LocaleState {
  final String locale;

  const LocaleLoaded(this.locale) : super();

  @override
  List<Object> get props => [locale, ...super.props];
}
