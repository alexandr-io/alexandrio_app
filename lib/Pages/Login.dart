import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import 'LoginPassword.dart';
import 'Register.dart';

class LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    var loginController = TextEditingController();

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
                    "Sign in",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32.0,
                  ),
                  child: Text(
                    "with your Alexandrio Account.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email or phone",
                    ),
                    controller: loginController,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: FlatButton(
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {},
                    child: Text(
                      "Forgot email?",
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
                FlatButton(
                  onPressed: () async => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Register(),
                    ),
                  ),
                  child: Text("Create account"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: RaisedButton(
                    child: Text("Next"),
                    onPressed: () async => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginPassword(
                          login: loginController.text,
                        ),
                      ),
                    ),
                    elevation: 0.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class Login extends StatefulWidget {
    final bool showError;

  const Login({
    Key key,
    this.showError,
  }) : super(key: key);

  @override
  LoginState createState() => LoginState();
}
