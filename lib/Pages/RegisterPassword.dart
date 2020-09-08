import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class RegisterPasswordState extends State<RegisterPassword> {
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

class RegisterPassword extends StatefulWidget {
  final String login;

  const RegisterPassword({
    Key key,
    @required this.login,
  }) : super(key: key);

  @override
  RegisterPasswordState createState() => RegisterPasswordState();
}
