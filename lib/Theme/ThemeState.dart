import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeLoading extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode mode;
  final String color;

  const ThemeLoaded({
    @required this.mode,
    @required this.color,
  }) : super();

  @override
  List<Object> get props => [mode, ...super.props];

  ThemeLoaded copyWith({
    ThemeMode mode,
    String color,
  }) =>
      ThemeLoaded(
        mode: mode ?? this.mode,
        color: color ?? this.color,
      );
}
