import 'dart:developer';

import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
import '../App.dart';
import '../backend/User.dart';
// import '../backend/Connection.dart';
// import '../backend/APIConnector.dart';

class LoginPasswordState extends State<LoginPassword> {
  @override
  Widget build(BuildContext context) {
    var api = context.findAncestorStateOfType<AppState>().api;
    var app = context.findAncestorStateOfType<AppState>();
    var passwordController = TextEditingController();

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
                    "Welcome",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32.0,
                  ),
                  child: Text(
                    widget.login,
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
                      labelText: "Enter your password",
                    ),
                    controller: passwordController,
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
                    User newUser = await api.login(widget.login, passwordController.text);
                    inspect(newUser);
                    if (newUser?.authToken != null || newUser?.refreshToken != null ) {
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

class LoginPassword extends StatefulWidget {
  final String login;

  const LoginPassword({
    Key key,
    @required this.login,
  }) : super(key: key);

  @override
  LoginPasswordState createState() => LoginPasswordState();
}
