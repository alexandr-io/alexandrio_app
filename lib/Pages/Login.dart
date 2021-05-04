import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:alexandrio_app/Credentials/CredentialsBloc.dart';
import 'package:alexandrio_app/Credentials/CredentialsEvent.dart';
import 'package:alexandrio_app/Credentials/CredentialsState.dart';
import 'package:alexandrio_app/Pages/Reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_tools/AppBarBlur.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Home.dart';
import 'Register.dart';
import 'Settings.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController;
  TextEditingController passwordController;

  @override
  void initState() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<CredentialsBloc, CredentialsState>(
        builder: (context, state) => Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBarBlur(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  tooltip: AppLocalizations.of(context).settingsButton,
                  onPressed: () async => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage(),
                  )),
                ),
              ],
            ),
          ),
          body: Builder(
            builder: (context) {
              if (state is CredentialsLoggedIn) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  var credentials = await AlexandrioAPI().loginUser(login: loginController.text, password: passwordController.text);
                  await Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(
                        credentials: credentials,
                      ),
                    ),
                    (route) => false,
                  );
                });
              } else if (state is CredentialsLoggedOut && state.error != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('${state.error}'),
                    ),
                  );
                });
              }

              return Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 256.0 * 1.5),
                  child: ListView(
                    children: [
                      Form(
                        child: Builder(
                          builder: (context) => Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height * 2.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Image.network(
                                    'https://i.imgur.com/kJJvK49.png',
                                    isAntiAlias: true,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: loginController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      labelText: AppLocalizations.of(context).loginField,
                                    ),
                                    // enabled: !(state is CredentialsLoggingIn),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      labelText: AppLocalizations.of(context).passwordField,
                                    ),
                                    obscureText: true,
                                    // enabled: !(state is CredentialsLoggingIn),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: OutlinedButton(
                                      onPressed:
                                          // (state is CredentialsLoggingIn)
                                          //     ? null
                                          //     :
                                          () async {
                                        Form.of(context).validate();
                                        BlocProvider.of<CredentialsBloc>(context).add(CredentialsLogin(login: loginController.text, password: passwordController.text, remember: true));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(AppLocalizations.of(context).loginButton),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TextButton(
                                      onPressed: () async => await Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) => RegisterPage(),
                                      )),
                                      child: Text(AppLocalizations.of(context).registerNewAccountButton),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TextButton(
                                      onPressed: () async => await Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) => ResetPage(),
                                      )),
                                      child: Text(AppLocalizations.of(context).lostAccountButton),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
}
