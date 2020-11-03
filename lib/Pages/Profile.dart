// import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import '../backend/User.dart';

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Icon(
              Icons.account_box,
              color: Colors.blue,
              size: 36.0,
            ),
            ListTile(
              leading: Icon(Icons.arrow_right),
              title: Text(widget.user.username),
              onTap: () async {
                print(widget.user.username);
              }
            ),
            ListTile(
              leading: Icon(Icons.arrow_right),
              title: Text(widget.user.email),
              onTap: () async {
                print(widget.user.email);
              }
            ),
            ListTile(
              leading: Icon(Icons.arrow_right),
              title: Text(widget.user.refreshToken),
              onTap: () async {
                print(widget.user.refreshToken);
              }
            ),
            ListTile(
              leading: Icon(Icons.arrow_right),
              title: Text(widget.user.authToken),
              onTap: () async {
                print(widget.user.authToken);
              }
            ),
            // RaisedButton(
            //   onPressed: () async {
            //   auth();
            //   },
            //   child: Text('Test connection')
            // ),
            // RaisedButton(
            //   onPressed: () async {
            //   login('test', 'coucou');
            //   },
            //   child: Text('Test login')
            // ),
            // RaisedButton(
            //   onPressed: () async {
            //   register('test', 'email@gmail.com', 'coucou', 'coucou');
            //   },
            //   child: Text('Test register')
            // ),
          ],
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