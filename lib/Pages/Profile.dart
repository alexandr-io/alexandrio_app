// import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';
import 'package:demo/Components/Logo.dart';

import '../backend/User.dart';

import 'Home.dart';
import '../App.dart';

class ProfileState extends State<Profile> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();

  void initState() {
    usernameController.text = widget.user.username;
    emailController.text = widget.user.email;
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var api = context.findAncestorStateOfType<AppState>().api;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RaisedButton(
                child: Text('Retour'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                        user: widget.user
                      ),
                    )
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48.0, bottom: 8.0),
                child: Logo(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your profile",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nom d'utilisateur",
                  ),
                  controller: usernameController
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                  controller: emailController
                )
              ),
              RaisedButton(
                child: Text('Update Profile'),
                onPressed: () async { 
                  await api.updateUser(emailController.text, usernameController.text, widget.user.authToken).then((response) async => {
                    await api.getUser(widget.user).then((response) => {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => Profile(
                              user: response,
                            ),
                          ),
                      )
                    })
                  });
                },
              ),
            ],
          )
        ),
      )
    );
  }
}

class Profile extends StatefulWidget {
  final User user;

  const Profile({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}