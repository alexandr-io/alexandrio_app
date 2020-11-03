import 'package:demo/Components/Logo.dart';
import 'package:demo/Pages/RegisterPassword.dart';
import 'package:flutter/material.dart';

import 'RegisterInfo.dart';

class RegisterEmailState extends State<RegisterEmail> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();

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
                    "Pick your email address",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32.0,
                  ),
                  child: Text(
                    "Pick an email address of your choice",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email address",
                    ),
                    controller: emailController,
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
                      builder: (BuildContext context) => RegisterPassword(
                        login: widget.login,
                        email: emailController.text,
                      ),
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
}

class RegisterEmail extends StatefulWidget {
  final String login;

  const RegisterEmail({
    Key key,
    @required this.login,
  }) : super(key: key);

  @override
  RegisterEmailState createState() => RegisterEmailState();
}