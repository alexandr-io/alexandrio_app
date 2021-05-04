import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CredentialsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CredentialsLogin extends CredentialsEvent {
  final String login;
  final String password;
  final bool remember;

  CredentialsLogin({
    @required this.login,
    @required this.password,
    @required this.remember,
  });

  @override
  List<Object> get props => [login, password, ...super.props];
}

class CredentialsLogout extends CredentialsEvent {}
