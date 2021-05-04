import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CredentialsState extends Equatable {
  @override
  List<Object> get props => [];
}

class CredentialsLoggedOut extends CredentialsState {
  final String error;

  CredentialsLoggedOut({
    this.error,
  });

  @override
  List<Object> get props => [error, ...super.props];
}

class CredentialsLoggingIn extends CredentialsState {}

class CredentialsLoggedIn extends CredentialsState {
  final String login;
  final String password;
  final bool remember;

  CredentialsLoggedIn({
    @required this.login,
    @required this.password,
    @required this.remember,
  });

  @override
  List<Object> get props => [login, password, remember, ...super.props];
}
