import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class LoginPasswordState extends State<LoginPassword> {
  @override
  Widget build(BuildContext context) => Scaffold(
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
                  onPressed: () async => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(),
                    ),
                  ),
                  elevation: 0.0,
                ),
              ],
            ),
          ),
        ),
      );
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
