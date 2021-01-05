// import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import '../backend/User.dart';

class ProfileState extends State<Profile> {
  void updateUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ListView(
              children: [
                Icon(
                  Icons.account_box,
                  color: Colors.blue,
                  size: 36.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: widget.user.username,
                  ),
                  enabled: false,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: widget.user.email,
                  ),
                  enabled: false,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: widget.user.refreshToken,
                  ),
                  enabled: false,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: widget.user.authToken,
                  ),
                  enabled: false,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
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
