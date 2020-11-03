import 'dart:developer';

import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
import '../App.dart';
import '../backend/User.dart';

class RegisterPasswordState extends State<RegisterPassword> {
  @override
  Widget build(BuildContext context) {
    var api = context.findAncestorStateOfType<AppState>().api;
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();

      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 48.0, bottom: 8.0),
                  child: Logo(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Create a strong password",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32.0,
                  ),
                  child: Text(
                    "Create a strong password with a mix of letters, numbers and symbols",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                    controller: passwordController,
                  ),
                ),
                SizedBox.fromSize(size: Size.fromHeight(24.0)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirm",
                    ),
                    controller: confirmPasswordController,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RaisedButton(
                  child: Text("Next"),
                  onPressed: () async {
                    User newUser = await api.register(widget.login, widget.email, passwordController.text, confirmPasswordController.text);
                    if (newUser?.authToken != null || newUser?.refreshToken != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Home(
                            user: newUser,
                          ),
                        ),
                      );
                    } else {
                      print("An error occured, please retry");
                    }
                  },
                  elevation: 0.0,
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class RegisterPassword extends StatefulWidget {
  final String login;
  final String email;

  const RegisterPassword({
    Key key,
    @required this.login,
    @required this.email,
  }) : super(key: key);

  @override
  RegisterPasswordState createState() => RegisterPasswordState();
}
