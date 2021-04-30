import 'dart:convert';

import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_tools/AppBarBlur.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:http/http.dart' as http;

import 'Home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController loginController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController invitationController;

  @override
  void initState() {
    loginController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    invitationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBarBlur(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ),
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 256.0 * 1.5),
            child: Form(
              child: Builder(
                builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: invitationController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: AppLocalizations.of(context).invitationToken,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.catching_pokemon),
                            onPressed: () async {
                              var response = await http.get(Uri.parse('https://auth.preprod.alexandrio.cloud/invitation/new'));
                              if (response.statusCode != 200) return;
                              var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                              invitationController.text = jsonResponse['token'];
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(size: Size.fromHeight(32.0)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: loginController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: AppLocalizations.of(context).loginField,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: AppLocalizations.of(context).emailField,
                        ),
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
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            Form.of(context).validate();
                            try {
                              var credentials = await AlexandrioAPI().registerUser(invitationToken: invitationController.text, login: loginController.text, email: emailController.text, password: passwordController.text);
                              await Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => HomePage(
                                    credentials: credentials,
                                  ),
                                ),
                                (route) => false,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(e),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(AppLocalizations.of(context).registerButton),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
