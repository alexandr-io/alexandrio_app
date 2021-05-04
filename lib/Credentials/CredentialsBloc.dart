import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CredentialsEvent.dart';
import 'CredentialsState.dart';

class CredentialsBloc extends Bloc<CredentialsEvent, CredentialsState> {
  CredentialsBloc() : super(CredentialsLoggedOut());

  @override
  Stream<CredentialsState> mapEventToState(CredentialsEvent event) async* {
    if (event is CredentialsLogin) {
      try {
        yield CredentialsLoggingIn();
        await AlexandrioAPI().loginUser(
          login: event.login,
          password: event.password,
        );
        yield CredentialsLoggedIn(login: event.login, password: event.password, remember: event.remember);
      } catch (e) {
        yield CredentialsLoggedOut(error: '$e');
      }
    } else if (event is CredentialsLogout) {
      yield CredentialsLoggedOut();
    }
  }
}
