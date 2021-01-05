import 'dart:developer';

import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
import 'Register.dart';
import '../App.dart';

class RegisterPasswordState extends State<RegisterPassword> {
  @override
  Widget build(BuildContext context) {
    var api = context.findAncestorStateOfType<AppState>().api;
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    var invitationController = TextEditingController();

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
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Text(
                    "Invitation token",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: Text(
                    "Add your invitation token",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox.fromSize(size: Size.fromHeight(24.0)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Invitation code",
                    ),
                    controller: invitationController,
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
                    await api.register(widget.login, widget.email, passwordController.text, confirmPasswordController.text, invitationController.text).then((response) => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Home(
                            user: response,
                          ),
                        ),
                      )
                    }).catchError((e) {
                      print(e);
                      _showMyDialog();
                    });
                  },
                  elevation: 0.0,
                ),
              ],
            ),
          ),
        ),
      );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('An error occured...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Internal server error, please retry'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Register()
                )
              );
              },
            ),
          ],
        );
      },
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
