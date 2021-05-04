import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'CredentialsEvent.dart';
import 'CredentialsState.dart';

class CredentialsBloc extends Bloc<CredentialsEvent, CredentialsState> {
  Box credentialsBox;

  CredentialsBloc(this.credentialsBox) : super(CredentialsLoggedOut()) {
    add(CredentialsPreviousLogin());
  }

  @override
  Stream<CredentialsState> mapEventToState(CredentialsEvent event) async* {
    if (event is CredentialsLogin) {
      try {
        yield CredentialsLoggingIn();
        await AlexandrioAPI().loginUser(
          login: event.login,
          password: event.password,
        );
        if (event.remember) {
          await credentialsBox.put('login', event.login);
          await credentialsBox.put('password', event.password);
        }
        yield CredentialsLoggedIn(login: event.login, password: event.password, remember: event.remember);
      } catch (e) {
        yield CredentialsLoggedOut(error: '$e');
      }
    } else if (event is CredentialsLogout) {
      await credentialsBox.delete('login');
      await credentialsBox.delete('password');
      yield CredentialsLoggedOut();
    } else if (event is CredentialsPreviousLogin) {
      var login = await credentialsBox.get('login');
      var password = await credentialsBox.get('password');
      if (login != null && password != null) add(CredentialsLogin(login: login, password: password, remember: true));
    }
  }
}
