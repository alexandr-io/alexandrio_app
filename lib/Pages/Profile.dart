// import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';
import 'package:demo/Components/Logo.dart';

import '../backend/User.dart';

import 'Landing.dart';
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
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nom d'utilisateur",
                  ),
                  controller: usernameController
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                  controller: emailController
                )
              ),
              RaisedButton(
                child: Text('Mettre à jour'),
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
                    }).catchError((e) {
                    print(e);
                    _showMyDialog();
                    })
                  }).catchError((e) {
                    print(e);
                    _showMyDialog();
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top:48.0, bottom: 8.0),
                child: RaisedButton(
                  child: Text('Supprimer son compte'),
                  onPressed: () async {
                    await api.deleteUser(widget.user.authToken).then((response) => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Landing()
                        )
                      )
                    }).catchError((e) {
                      print(e);
                      _showMyDialog();
                    });
                  },
                )
              )
            ],
          )
        ),
      )
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
                  builder: (BuildContext context) => Profile(user: widget.user)
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

class Profile extends StatefulWidget {
  final User user;

  const Profile({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}
